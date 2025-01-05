class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :event_id
      t.string :user_id

      t.timestamps

      t.index :event_id
      t.index :user_id
    end
  end
end
