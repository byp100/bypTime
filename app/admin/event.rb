ActiveAdmin.register Event do
  permit_params :title, :event_type, :description, :start_time, :end_time, :location, :address

  show do
    attributes_table do
      row :title
      row :event_type
      row :description
      row :start_time
      row :end_time
      row :location
      row :address
    end

    panel 'Attendees' do
      table_for event.attendances do
        column 'name' do |attendance|
          attendance.user.name
        end
        column :in_attendance
      end
    end
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    inputs 'Details' do
      input :title
      input :event_type, as: :select, collection: Event.event_types.keys.map { |k,v| [k.titleize, k]}
      input :description
      input :start_time
      input :end_time
      input :location
      input :address
    end
    # f.inputs          # builds an input field for every attribute

    f.has_many :attendees, heading: 'Attendees', new_record: false do |a|
      a.input :name
      a.input :in_attendance, as: :boolean
    end
    
    f.actions
  end
end
