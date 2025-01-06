require "rails_helper"

describe TicketBookingService do
  let(:event) { create(:event, total_tickets_count: 20, sold_tickets_count: 0) }
  let(:event_id) { event.id }
  let(:count) { 2 }
  let(:current_user) { event.creator }

  subject { described_class.new(event_id, count, current_user).call }

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

    it "locks event row before booking tickets" do
      # with_lock is Rails internals and we do not need to test that - mocking it should be enough
      allow(Event).to receive(:find_by).and_return(event)
      expect(event).to receive(:with_lock).and_call_original

      subject
    end

    it "hits validation error when concurrent users" do
      # We mimic concurrency here by using stale event record
      stale_event = Event.find(event.id)

      allow(Event).to receive(:find_by).and_return(event)
      subject

      allow(Event).to receive(:find_by).and_return(stale_event)
      expect(stale_event.sold_tickets_count).to eq(0) # no tickets booked on this stale object yet
      second_result = described_class.new(event_id, 19, current_user).call
      expect(second_result.failure).to eq("Validation failed: Sold tickets count must be equal to or less than total tickets")
    end

    it "hits database constraint when peak concurrency" do
      stale_event = Event.find(event.id)

      allow(Event).to receive(:find_by).and_return(event)
      subject

      allow(Event).to receive(:find_by).and_return(stale_event)
      allow(stale_event).to receive(:valid?).and_return(true) # skip validation to hit DB constaint
      expect(stale_event.sold_tickets_count).to eq(0) # no tickets booked on this stale object yet
      second_result = described_class.new(event_id, 19, current_user).call
      expect(second_result.failure).to include("PG::CheckViolation: ERROR:")
    end
  end
end
