require 'rails_helper'

RSpec.describe User, type: :model do
  describe "authentication" do
    it { is_expected.to have_secure_password }
  end

  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end
end
