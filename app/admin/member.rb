ActiveAdmin.register Member do
  permit_params :name, :email, :phone, :password, :password_confirmation

  index do
    column :name
    column :email
    column :phone
    column :address
    column :birthdate
    column :occupation
    column :member
    actions
  end

  filter :phone
  filter :email
  filter :name
  filter :birthdate

  form do |f|
    f.inputs "Member Details" do
      f.input :name
      f.input :phone
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
