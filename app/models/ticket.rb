class Ticket < ApplicationRecord
  # Associations
  belongs_to :event
  belongs_to :user

  # Scopes
  scope :for_user, ->(user) { where(user: user) }
end
