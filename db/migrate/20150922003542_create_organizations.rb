class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :type
      t.string :slug
      t.string :short_name

      t.timestamps null: false
    end

    add_index :organizations, :slug
  end
end
