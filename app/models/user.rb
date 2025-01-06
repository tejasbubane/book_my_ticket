class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :tickets
  has_many :events, through: :tickets
  has_many :created_events, class_name: Event.to_s, foreign_key: :creator_id

  # Validations
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.strip.downcase }
end
