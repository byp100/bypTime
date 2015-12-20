Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/import'

  devise_for :users
  resources :users do
    post 'check_in'
    collection { post :import }
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :events do
    collection do
      post :import_events, as: 'import'
      post :import_attendances, as: 'import_attendances'
    end
  end
  put 'unattend' => 'events#unattend', as: 'unattend'

  devise_scope :user do
    post 'create_attendee' => 'users#create_attendee', as: 'create_attendee'
  end
end
