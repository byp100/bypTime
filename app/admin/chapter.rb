ActiveAdmin.register Chapter do
  permit_params :name, :subdomain

  index do
    column :name
    column :subdomain
    actions
  end

  filter :name
  filter :subdomain

  form do |f|
    f.inputs "Chapter Details" do
      f.input :name
      f.input :subdomain
    end
    f.actions
  end
end