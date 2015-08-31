class AddAttributesToMember < ActiveRecord::Migration
  def change
    add_column :members, :nickname, :string
    add_column :members, :native_city, :string
    add_column :members, :gender, :integer
    add_column :members, :preferred_pronouns, :string
    add_column :members, :sexual_orientation, :integer
    add_column :members, :home_phone, :string
    add_column :members, :student, :boolean
    add_column :members, :join_date, :date
    add_column :members, :committee_membership, :integer
    add_column :members, :superpowers, :string
    add_column :members, :twitter, :string
    add_column :members, :facebook, :string
    add_column :members, :instagram, :string
    add_column :members, :education_level, :integer
    add_column :members, :children, :integer
    add_column :members, :partnership_status, :integer
    add_column :members, :income, :integer
    add_column :members, :household_size, :integer
    add_column :members, :dietary_restrictions, :string
    add_column :members, :immigrant, :boolean
    add_column :members, :country_of_origin, :string
  end
end
