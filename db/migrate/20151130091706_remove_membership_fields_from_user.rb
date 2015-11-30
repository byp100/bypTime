class RemoveMembershipFieldsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :member, :boolean
    remove_column :users, :admin, :boolean
  end
end
