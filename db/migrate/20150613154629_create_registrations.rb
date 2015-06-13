class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :user_id
      t.string :name
      t.string :ip_address
      t.string :email
      t.string :country

      t.timestamps null: false
    end
  end
end
