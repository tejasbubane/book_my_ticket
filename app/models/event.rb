class Event < ApplicationRecord
  # Association
  has_many :tickets, counter_cache: :tickets_sold
  has_many :users, through: :tickets

  # Validations
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :total_tickets_count, presence: true
  validate do |event|
    if event.sold_tickets_count.to_i > event.total_tickets_count.to_i
      errors.add(:sold_tickets_count, message: "must be equal to or less than total tickets")
    end
  end

  def available_tickets_count
    total_tickets_count.to_i - sold_tickets_count.to_i
  end

  def can_book?(ticket_count)
    ticket_count.to_i <= available_tickets_count.to_i
  end
end
