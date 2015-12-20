class AddOwnerIdToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :owner_id, :integer
  end
end
