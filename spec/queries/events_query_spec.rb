require "rails_helper"

describe EventsQuery do
  let!(:current_user) { create(:user) }
  let!(:past_events_current_user) { create_list(:event, 2, starts_at: 3.hours.ago, creator: current_user) }
  let!(:future_events_current_user) { create_list(:event, 2, starts_at: 3.hours.from_now, creator: current_user) }
  let!(:past_events_other_user) { create_list(:event, 2, starts_at: 3.hours.ago) }
  let!(:future_events_other_user) { create_list(:event, 2, starts_at: 3.hours.from_now) }
  let(:all_past_events) { past_events_current_user + past_events_other_user }
  let(:all_future_events) { future_events_current_user + future_events_other_user }
  let(:filter) { {} }

  subject { described_class.call(current_user, filter) }

  context "created events" do
    let(:filter) { { created: true } }

    it "returns events created by user" do
      expect(subject.ids).to match_array((past_events_current_user + future_events_current_user).map(&:id))
    end
  end

  context "booked events" do
    let(:filter) { { booked: true } }

    before do
      future_events_other_user.each do |event|
        create_list(:ticket, 2, event:, user: current_user)
      end
    end

    it "returns events booked by user" do
      expect(subject.ids).to match_array(future_events_other_user.map(&:id))
    end
  end

  context "all events" do
    it "returns all future events" do
      expect(subject.ids).to match_array((future_events_current_user + future_events_other_user).map(&:id))
    end
  end
end
