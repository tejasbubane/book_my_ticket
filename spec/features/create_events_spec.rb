require "rails_helper"

feature "User creates event" do
  let(:email) { "foobar@example.com" }
  let(:password) { "super_secret_password" }
  let(:event_name) { "First Event" }
  let!(:current_user) { create(:user, email:, password:, password_confirmation: password) }

  scenario "when all data is correct" do
    log_in_with email, password
    click_link "Create Event"

    fill_in "Name", with: event_name
    fill_in "Description", with: "This is my first event"
    fill_in "Location", with: "Dubai Mall"
    fill_in "Starts at", with: "07 / 01 / 2025, 01:00 pm"
    fill_in "Number of tickets", with: 100
    click_button "Create"

    expect(Event.find_by(name: event_name, creator: current_user)).to be_present

    expect(page).to have_content(event_name)
    expect(page).to have_content("This is my first event")
    expect(page).to have_content("Dubai Mall")
    expect(page).to have_content("7 Jan 2025 01:00 pm")
  end
end
