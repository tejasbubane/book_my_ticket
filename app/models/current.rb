# Thread-isolated singleton
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
