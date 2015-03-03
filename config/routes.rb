Rails.application.routes.draw do
  devise_for :members
  resources :members
  root 'static_pages#home'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :events

  devise_scope :member do
    post 'new_attendee' => 'members#create_attendee'
  end
end
