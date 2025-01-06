class Event < ApplicationRecord
  # Association
  has_many :tickets, counter_cache: :tickets_sold
  has_many :users, through: :tickets
  belongs_to :creator, class_name: User.to_s

  # Validations
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :total_tickets_count, presence: true
  validate do |event|
    if event.sold_tickets_count.to_i > event.total_tickets_count.to_i
      errors.add(:sold_tickets_count, message: "must be equal to or less than total tickets")
    end
  end

  # Scopes
  scope :future, -> { where("starts_at >= ?", Time.current) }
  scope :recent_first, -> { order(:starts_at) }

  def available_tickets_count
    total_tickets_count.to_i - sold_tickets_count.to_i
  end

  def can_book?(ticket_count)
    ticket_count.to_i <= available_tickets_count.to_i
  end

  def past?
    starts_at <= Time.current
  end
end
