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

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute

    f.has_many :attendees, heading: 'Attendees', new_record: false do |a|
      a.input :name
      a.input :in_attendance, as: :boolean
    end
    
    f.actions
  end
end
