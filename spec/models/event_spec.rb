require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:tickets).counter_cache(:tickets_sold) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to belong_to(:creator) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:total_tickets_count) }

    describe "sold_tickets_count" do
      it "fails when sold tickets are more than total tickets" do
        event = build(:event, total_tickets_count: 20, sold_tickets_count: 21)
        expect(event).not_to be_valid
        expect(event.errors[:sold_tickets_count]).to eq([ "must be equal to or less than total tickets" ])
      end
    end
  end

  describe "#available_tickets_count" do
    subject { build(:event, total_tickets_count: 30, sold_tickets_count: 2) }

    it "returns available tickets for this event" do
      expect(subject.available_tickets_count).to eq(28)
    end
  end

  describe "#can_book?" do
    subject { build(:event, total_tickets_count: 30, sold_tickets_count: 22) }

    it "can book upto available tickets" do
      expect(subject.can_book?(5)).to be(true)
      expect(subject.can_book?(8)).to be(true)
      expect(subject.can_book?(9)).to be(false)
    end
  end

  describe "#past?" do
    let(:past_event) { build(:event, starts_at: 2.hours.ago) }
    let(:running_event) { build(:event, starts_at: Time.current) }
    let(:future_event) { build(:event, starts_at: 1.hour.from_now) }

    it "checks if event is past" do
      expect(past_event).to be_past
      expect(running_event).to be_past
      expect(future_event).not_to be_past
    end
  end
end
