class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps

      t.index :email, unique: true
    end
  end
end
