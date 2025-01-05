class RenameFieldsToCountsInEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :total_tickets, :total_tickets_count
    rename_column :events, :sold_tickets, :sold_tickets_count
  end
end
