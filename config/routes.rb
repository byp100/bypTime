Rails.application.routes.draw do
  devise_for :members
  resources :members

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'static_pages/home'
  get 'static_pages/about'

  resources :events
  root 'static_pages#home'
  put 'unattend' => 'events#unattend', as: 'unattend'

  devise_scope :member do
    post 'create_attendee' => 'members#create_attendee', as: 'create_attendee'
  end
end
