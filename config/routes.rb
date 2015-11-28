Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'

  devise_for :users
  resources :users do
    post 'check_in'
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :events
  put 'unattend' => 'events#unattend', as: 'unattend'

  devise_scope :user do
    post 'create_attendee' => 'users#create_attendee', as: 'create_attendee'
  end
end
