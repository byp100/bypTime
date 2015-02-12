ActiveAdmin.register User do

  index do
    column :username
    default_actions
  end

  filter :username

  form do |f|
    f.inputs "User Details" do
      f.input :username
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:username, :password, :password_confirmation]
    end
  end
end
