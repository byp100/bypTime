class AddFieldsToUser < ActiveRecord::Migration
  def change
  	create_table :users do |t|
     t.timestamps null: false
   end
    add_column :users, :name, :string
    add_column :users, :birthdate, :datetime
    add_column :users, :email, :string
    add_column :users, :address, :string
    add_column :users, :phone, :string
    add_column :users, :occupation, :string
    add_column :users, :member, :boolean
  end
end
