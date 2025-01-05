class Event < ApplicationRecord
  # Association
  has_many :tickets, counter_cache: :tickets_sold
  has_many :users, through: :tickets

  # Validations
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :total_tickets, presence: true
end
