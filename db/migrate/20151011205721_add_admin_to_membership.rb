class AddAdminToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :admin, :boolean
  end
end
