class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name
      t.string :subdomain

      t.timestamps null: false
    end
  end
end
