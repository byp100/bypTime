class RenameMemberToUser < ActiveRecord::Migration
  def change
    #remove_index :attendances, column: :member_id
    rename_table :members, :users
    #add_reference :attendances, :user, index: true
  end
end
