require "rails_helper"

feature "User books tickets" do
  let(:email) { "foobar@example.com" }
  let(:password) { "super_secret_password" }

  before { create(:user, email:, password:, password_confirmation: password) }

  context "when more tickets available" do
    before do
      create(:event, total_tickets_count: 20, sold_tickets_count: 0)
      log_in_with email, password
      click_link "Book now"
    end

    scenario "when booking single ticket" do
      click_button "Confirm Booking"
      expect(page).to have_content("1 ticket booked successfully! Enjoy the show!")
    end

    scenario "when booking multiple tickets" do
      select "3", from: "Qty:"
      click_button "Confirm Booking"
      expect(page).to have_content("3 tickets booked successfully! Enjoy the show!")
    end
  end

  context "when less tickets available" do
    before do
      create(:event, total_tickets_count: 20, sold_tickets_count: 19)
      log_in_with email, password
      click_link "Book now"
    end

    it "shows only remaining options" do
      expect(page).to have_select("Qty:", options: [ "1" ])
    end
  end
end
