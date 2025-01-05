class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :tickets
  has_many :events, through: :tickets

  # Validations
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.strip.downcase }
end
