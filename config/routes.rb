Rails.application.routes.draw do
  devise_for :members
  resources :members

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :events
  root 'events#index'
  put 'unattend' => 'events#unattend', as: 'unattend'

  devise_scope :member do
    post 'create_attendee' => 'members#create_attendee', as: 'create_attendee'
  end
end
