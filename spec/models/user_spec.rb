require 'rails_helper'

RSpec.describe User, type: :model do
  describe "authentication" do
    it { is_expected.to have_secure_password }
  end

  describe "associations" do
    it { is_expected.to have_many(:tickets) }
    it { is_expected.to have_many(:events) }
  end

  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    describe "email format" do
      it "validates email format" do
        user = build(:user, email: "foobar")
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end
    end
  end
end
