require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:event) }
    it { is_expected.to belong_to(:user) }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let!(:user_tickets) { create_list(:ticket, 2, user:) }
    let!(:other_tickets) { create_list(:ticket, 2) }

    it "returns tickets for given user" do
      expect(Ticket.for_user(user).ids).to match_array(user_tickets.map(&:id))
    end
  end
end
