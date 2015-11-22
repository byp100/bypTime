class AddCustomerIdToMember < ActiveRecord::Migration
  def change
    add_column :members, :customer_id, :string
  end
end
