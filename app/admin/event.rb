ActiveAdmin.register Event do
  permit_params :title, :description, :start_time, :end_time, :location, :address

  show do
    attributes_table do
      row :title
      row :description
      row :start_time
      row :end_time
      row :location
      row :address
    end

    panel 'Attendees' do
      table_for event.attendances do
        column 'name' do |attendance|
          attendance.member.name
        end
        column :in_attendance
      end
    end
  end
end
