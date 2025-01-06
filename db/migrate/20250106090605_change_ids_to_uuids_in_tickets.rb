class ChangeIdsToUuidsInTickets < ActiveRecord::Migration[8.0]
  def up
    change_column :tickets, :event_id, :uuid, using: "event_id::uuid"
    change_column :tickets, :user_id, :uuid, using: "user_id::uuid"
  end

  def down
    change_column :tickets, :event_id, :string, using: "event_id::string"
    change_column :tickets, :user_id, :string, using: "user_id::string"
  end
end
