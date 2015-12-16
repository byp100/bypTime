class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true

  def self.import file
    CSV.foreach(file.path, headers: true) do |row|
      user = User.find_by_phone(row.first)

      for index in 1..(row.size-1)
        next if row[index] == nil
        Attendance.create(user: user, event: Event.find(row[index]))
      end
    end
  end
end
