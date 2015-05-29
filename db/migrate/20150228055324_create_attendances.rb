class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.belongs_to :member, index: true
      t.belongs_to :event, index: true
      t.boolean :in_attendance, default: false
      t.timestamps null: false
    end
  end
end
