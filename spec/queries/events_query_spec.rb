require "rails_helper"

describe EventsQuery do
  let!(:current_user) { create(:user) }
  let!(:past_events_current_user) { create_list(:event, 2, starts_at: 3.hours.ago, creator: current_user) }
  let!(:future_events_current_user) do
    [
      create(:event, creator: current_user, starts_at: 4.hours.from_now),
      create(:event, creator: current_user, starts_at: 3.hours.from_now)
    ]
  end
  let!(:past_events_other_user) { create_list(:event, 2, starts_at: 3.hours.ago) }
  let!(:future_events_other_user) do
    [
      create(:event, starts_at: 4.hours.from_now),
      create(:event, starts_at: 3.hours.from_now)
    ]
  end
  let(:all_past_events) { past_events_current_user + past_events_other_user }
  let(:all_future_events) { future_events_current_user + future_events_other_user }
  let(:filter) { {} }

  subject { described_class.call(current_user, filter) }
  let(:received_event_ids) { subject.map(&:id) }

  context "created events" do
    let(:filter) { { created: true } }

    it "returns events created by user in recent first order" do
      expected_event_ids = (past_events_current_user + future_events_current_user).sort_by(&:starts_at).map(&:id)
      expect(received_event_ids).to eq(expected_event_ids)
    end
  end

  context "booked events" do
    let(:filter) { { booked: true } }

    before do
      future_events_other_user.each do |event|
        create_list(:ticket, 2, event:, user: current_user)
      end
    end

    it "returns events booked by user in recent first order" do
      expect(received_event_ids).to eq(future_events_other_user.sort_by(&:starts_at).map(&:id))
    end
  end

  context "all events" do
    it "returns all future events in recent first order" do
      expected_event_ids = (future_events_current_user + future_events_other_user).sort_by(&:starts_at).map(&:id)
      expect(received_event_ids).to eq(expected_event_ids)
    end
  end
end
