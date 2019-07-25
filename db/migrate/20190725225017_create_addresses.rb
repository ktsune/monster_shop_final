class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :nickname
      t.references :user, foreign_key: true
    end
  end
end
