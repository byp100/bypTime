class AddAttributesToMemberbutesToMember < ActiveRecord::Migration
  def change
    add_column :members, :pronouns, :string
    add_column :members, :referred_by, :string
  end
end
