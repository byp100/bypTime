ActiveAdmin.register Member do
  permit_params :name, :email, :phone, :password, :password_confirmation

  index do
    column :name
    column :email
    column :phone
    column :birthdate
    column :occupation
    column :address
    column :member
    column :admin
    actions
  end

  filter :phone
  filter :email
  filter :name
  filter :birthdate
  filter :member
  filter :admin

  form do |f|
    f.inputs "Member Details" do
      f.input :name
      f.input :phone
      f.input :email
      f.input :birthdate
      f.input :occupation
      f.input :address
      f.input :member
      f.input :admin
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
