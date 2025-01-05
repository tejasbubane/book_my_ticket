class AddConstraintOnSoldTicketsCountForEvents < ActiveRecord::Migration[8.0]
  def change
    add_check_constraint :events, "sold_tickets_count <= total_tickets_count", name: :sold_tickets_count_check
  end
end
