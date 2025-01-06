require "rails_helper"

feature "User sees list of events" do
  let(:email) { "foobar@example.com" }
  let(:password) { "super_secret_password" }
  let!(:current_user) { create(:user, email:, password:, password_confirmation: password) }
  let!(:past_events) { create_list(:event, 2, starts_at: 2.hours.ago) }
  let!(:future_events) { create_list(:event, 2, starts_at: 2.hours.from_now) }

  it "does not show past events" do
    log_in_with email, password

    past_events.each do |event|
      expect(page).not_to have_content(event.name)
    end
    future_events.each do |event|
      expect(page).to have_content(event.name)
    end
  end
end
