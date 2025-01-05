class Event < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :total_tickets, presence: true
  validate do |event|
    if event.available_tickets.to_i > event.total_tickets.to_i
      errors.add(:available_tickets, message: "must be equal to or less than total tickets")
    end
  end

  before_create do
    self.available_tickets = total_tickets
  end
end
