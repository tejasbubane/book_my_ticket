class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.strip.downcase }
end
