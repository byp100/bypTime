class AddChapterToEventsAndUsers < ActiveRecord::Migration
  def change
    add_reference :events, :chapter, index: true, foreign_key: true
    add_reference :users, :chapter, index: true, foreign_key: true
  end
end
