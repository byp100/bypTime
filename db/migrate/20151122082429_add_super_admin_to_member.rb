class AddSuperAdminToMember < ActiveRecord::Migration
  def change
    add_column :members, :super_admin, :boolean
  end
end
