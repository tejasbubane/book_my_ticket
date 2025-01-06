require "rails_helper"

describe TicketBookingService do
  let(:event) { create(:event, total_tickets_count: 20, sold_tickets_count: 0) }
  let(:event_id) { event.id }
  let(:count) { 2 }
  let(:current_user) { event.creator }

  subject { described_class.call(event_id, count, current_user) }

  context "when event does not exist" do
    let(:event_id) { SecureRandom.uuid }

    it 'returns failure' do
      expect(subject.success).to be(nil)
      expect(subject.failure).to eq("Event with ID #{event_id} not found")
    end
  end

  context "when requested quantity is not available" do
    let(:event) { create(:event, total_tickets_count: 20, sold_tickets_count: 19) }

    it "return failure" do
      expect(subject.success).to be(nil)
      expect(subject.failure).to eq("Sorry, requested quantity of tickets are not available")
    end
  end

  context "when tickets are available" do
    it "books tickets" do
      expect { subject }.to change(Ticket, :count).by(count).and change { event.reload.sold_tickets_count }.from(0).to(count)
      expect(subject.success.id).to eq(event.id)
      expect(subject.failure).to be(nil)
    end
  end
end
