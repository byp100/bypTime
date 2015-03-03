class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :member_id
      t.integer :event_id

      t.timestamps null: false
    end

    add_index :attendances, :member_id
    add_index :attendances, :event_id
    add_index :attendances, [:member_id, :event_id], unique: true
  end
end
