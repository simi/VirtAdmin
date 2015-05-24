class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :zip, :string
    add_column :users, :phone, :string
    add_column :users, :contact_person, :string
    add_column :users, :skype, :string
    add_column :users, :jabber, :string
    add_column :users, :billing_emails, :string
    add_column :users, :company_number, :string
    add_column :users, :vat_number, :string
    add_column :users, :blocked, :boolean, default: false
  end
end
