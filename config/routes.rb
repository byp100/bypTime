Rails.application.routes.draw do
  devise_for :members
  resources :members do
    member do
      post 'check_in'
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'static_pages/home'
  get 'static_pages/about'

  resources :events
  root 'static_pages#home'
  put 'unattend' => 'events#unattend', as: 'unattend'
  put 'check_in' => 'events#check_in', as: 'check_in'
  put 'undo_check_in' => 'events#undo_check_in', as: 'undo_check_in'

  devise_scope :member do
    post 'create_attendee' => 'members#create_attendee', as: 'create_attendee'
  end
end
