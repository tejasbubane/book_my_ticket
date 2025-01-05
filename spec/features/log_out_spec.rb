require "rails_helper"

feature "User logs out" do
  let(:password) { "super_secret_password" }
  let!(:user) { create(:user, password:, password_confirmation: password) }

  it "redirects to login page" do
    log_in_with(user.email, password)

    click_button "Log out"
    expect(page).not_to have_content("All Events")
    expect(page).to have_content("Log In")
  end
end
