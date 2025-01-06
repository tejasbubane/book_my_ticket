require "rails_helper"

# Use custom RSpec matcher `have_event` defined in spec/support/event_helper.rb

feature "User sees list of events" do
  let(:email) { "foobar@example.com" }
  let(:password) { "super_secret_password" }
  let!(:current_user) { create(:user, email:, password:, password_confirmation: password) }
  let!(:past_events_current_user) { create_list(:event, 2, starts_at: 2.hours.ago, creator: current_user) }
  let!(:future_events_current_user) { create_list(:event, 2, starts_at: 2.hours.from_now, creator: current_user) }
  let!(:past_events_other_user) { create_list(:event, 2, starts_at: 2.hours.ago) }
  let!(:future_events_other_user) { create_list(:event, 2, starts_at: 2.hours.from_now) }
  let(:all_past_events) { past_events_current_user + past_events_other_user }
  let(:all_future_events) { future_events_current_user + future_events_other_user }

  context "when showing all events" do
    it "does not show past events" do
      log_in_with email, password

      all_future_events.each do |event|
        expect(page).to have_event(event)
      end
      all_past_events.each do |event|
        expect(page).not_to have_event(event)
      end
    end
  end

  context "when showing events created by current user" do
    it "shows only events from current user" do
      log_in_with email, password
      click_link "My Events"

      (past_events_current_user + future_events_current_user).each do |event|
        expect(page).to have_event(event)
      end
      (past_events_other_user + future_events_other_user).each do |event|
        expect(page).not_to have_event(event)
      end
    end
  end

  context "when showing events booked my current user" do
    let!(:ticket) { create(:ticket, user: current_user, event: future_events_other_user.first) }

    it "shows only booked events" do
      log_in_with email, password
      click_link "My Bookings"

      expect(page).to have_event(ticket.event)
      future_events_current_user.each do |event|
        expect(page).not_to have_event(event)
      end
    end
  end
end
