Rails.application.routes.draw do
  devise_for :members
  resources :members

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :events
  root 'events#index'

  devise_scope :member do
    post 'new_attendee' => 'members#create_attendee'
  end
end
