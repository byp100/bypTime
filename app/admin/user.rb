ActiveAdmin.register User do
  permit_params :name, :email, :phone, :birthdate, :occupation, :address, :password, :password_confirmation

  index do
    column :name
    column :email
    column :phone
    column :birthdate
    column :occupation
    column :address
    actions
  end

  filter :phone
  filter :email
  filter :name
  filter :birthdate

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :phone
      f.input :email
      f.input :birthdate, :start_year => 1980,
                          :end_year => Date.today.year
      f.input :occupation
      f.input :address
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
end
