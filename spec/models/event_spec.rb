require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
    it { is_expected.to validate_presence_of(:total_tickets) }

    describe "available_tickets" do
      it "fails when available tickets are more than total tickets" do
        event = build(:event, total_tickets: 20, available_tickets: 21)
        expect(event).not_to be_valid
        expect(event.errors[:available_tickets]).to eq([ "must be equal to or less than total tickets" ])
      end
    end
  end
end
