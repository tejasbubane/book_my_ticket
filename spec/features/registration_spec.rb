require "rails_helper"

feature "User registers" do
  scenario "with valid email and password" do
    sign_up_with "foobar@example.com", "password", "password"

    expect(page).to have_content("All Events")
    expect(page).to have_content("Log out")
  end

  scenario "with invalid email" do
    sign_up_with "foobar", "password", "password"

    expect(page).to have_content("Log In")
  end

  scenario "with existing email" do
    create(:user, email: "foobar@example.com")
    sign_up_with "foobar@example.com", "password", "password"

    expect(page).to have_content("Email has already been taken")
    expect(page).to have_content("Log In")
  end

  scenario "with blank password" do
    sign_up_with "foobar@example.com", nil, nil

    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Log In")
  end

  scenario "when password and password confirmation does not match" do
    sign_up_with "foobar@example.com", "password", "another_password"

    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content("Log In")
  end

  def sign_up_with(email, password, password_confirmation)
    visit new_registrations_path
    fill_in "Full Name", with: "Tejas Bubane"
    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Password confirmation", with: password_confirmation
    click_button "Sign Up"
  end
end
