Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'

  devise_for :members
  resources :members do
    member do
      post 'check_in'
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :events
  put 'unattend' => 'events#unattend', as: 'unattend'

  devise_scope :member do
    post 'create_attendee' => 'members#create_attendee', as: 'create_attendee'
  end
end
