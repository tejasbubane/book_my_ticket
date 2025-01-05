class Ticket < ApplicationRecord
  # Associations
  belongs_to :event
  belongs_to :user
end
