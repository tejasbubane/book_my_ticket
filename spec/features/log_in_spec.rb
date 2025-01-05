require "rails_helper"

feature "User logs in" do
  let(:email) { "foobar@example.com" }
  let(:password) { "super_secret_password" }

  before { create(:user, email:, password:, password_confirmation: password) }

  scenario "with valid email and password" do
    log_in_with email, password

    expect(page).to have_content("All Events")
    expect(page).to have_content("Log out")
  end

  scenario "with invalid email" do
    log_in_with "tejas@example.com", password

    expect(page).to have_content("Invalid email or password.")
    expect(page).to have_content("Log In")
  end

  scenario "with blank password" do
    log_in_with "foobar@example.com", nil

    expect(page).to have_content("Invalid email or password.")
    expect(page).to have_content("Log In")
  end

  scenario "when invalid password" do
    log_in_with email, "another_password"

    expect(page).to have_content("Invalid email or password.")
    expect(page).to have_content("Log In")
  end
end
