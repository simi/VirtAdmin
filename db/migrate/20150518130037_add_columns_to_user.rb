class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :country, :string
    add_column :users, :locale, :string, default: 'en'
    add_column :users, :time_zone, :string, default: 'Prague'
    add_column :users, :approved, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end
end
