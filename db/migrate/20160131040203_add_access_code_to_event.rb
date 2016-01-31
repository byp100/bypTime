class AddAccessCodeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :access_code, :string
  end
end
