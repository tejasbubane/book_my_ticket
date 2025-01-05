class RenameAvailableTicketsToSoldTickets < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :available_tickets, :sold_tickets
  end
end
