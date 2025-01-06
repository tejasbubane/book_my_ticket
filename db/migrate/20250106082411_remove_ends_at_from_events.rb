class RemoveEndsAtFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :ends_at, :timestamp
  end
end
