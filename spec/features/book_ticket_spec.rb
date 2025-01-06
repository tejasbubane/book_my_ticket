require "rails_helper"

feature "User books tickets" do
  let(:email) { "foobar@example.com" }
  let(:password) { "super_secret_password" }

  before { create(:user, email:, password:, password_confirmation: password) }

  context "when more tickets available" do
    let!(:event) { create(:event, total_tickets_count: 20, sold_tickets_count: 0) }

    before do
      log_in_with email, password
      click_link "Book Now"
    end

    scenario "when booking single ticket" do
      click_button "Confirm Booking"
      expect(page).to have_content("1 ticket booked successfully! Enjoy the show!")

      expect(event.reload.sold_tickets_count).to eq(1)
    end

    scenario "when booking multiple tickets" do
      select "3", from: "Qty:"
      click_button "Confirm Booking"
      expect(page).to have_content("3 tickets booked successfully! Enjoy the show!")

      expect(event.reload.sold_tickets_count).to eq(3)
    end
  end

  context "when less tickets available" do
    let!(:event) { create(:event, total_tickets_count: 20, sold_tickets_count: 19) }

    before do
      log_in_with email, password
      click_link "Book Now"
    end

    it "shows only remaining options" do
      expect(page).to have_select("Qty:", options: [ "1" ])

      expect(event.reload.sold_tickets_count).to eq(19)
    end
  end
end
