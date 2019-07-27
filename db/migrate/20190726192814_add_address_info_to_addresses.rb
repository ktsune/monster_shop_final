class AddAddressInfoToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :address, :string
    add_column :addresses, :city, :string
    add_column :addresses, :state, :string
    add_column :addresses, :zip, :integer
  end
end
