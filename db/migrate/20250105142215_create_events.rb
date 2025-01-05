class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name
      t.string :description
      t.string :location
      t.timestamp :starts_at
      t.timestamp :ends_at
      t.integer :total_tickets, default: 0
      t.integer :available_tickets, default: 0

      t.timestamps
    end
  end
end
