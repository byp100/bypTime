Rails.application.routes.draw do

  root 'events#index'
  get 'select_chapter', to: 'static_pages#select_chapter', as: 'select_chapter'
  post 'switch_chapter', to: 'static_pages#chapter'

  scope 'webhooks', as: :messages do
    post 'chargebee_event', to: "webhooks#chargebee_event", as: :chargebee_event
  end

  get 'events/:event_id/join', to: "users#new", as: :new_event_user
  post 'events/:event_id/users', to: "users#create", as: :event_users

  post 'users/create_with_access_code', to: 'users#create_with_access_code', as: 'create_with_access_code'
  put 'users/:id/update_membership', to: "users#update_membership", as: :update_membership

  devise_for :users

  #devise_for :admin_users, ActiveAdmin::Devise.config
  #ActiveAdmin.routes(self)

  authenticated :user do
    resources :subscriptions
    resources :users do
      collection { post :import }
    end

    get 'admin', to: "admin#dashboard", as: :admin_dashboard
    get 'admin/import', to: "admin#import", as: :admin_import
    scope 'admin', as: :admin do
      get 'users', to: "users#index", as: :users
      get 'users/:id/edit', to: "users#edit", as: :edit_user
      post 'users/:user_id/check_in', to: "users#check_in", as: :user_check_in
      post 'users/import', to: "users#import", as: :user_import
    end

    resources :events do
      collection do
        post :import_events, as: 'import'
        post :import_attendances, as: 'import_attendances'
      end
    end
    get 'past_events', to: 'events#past_events', as: :past_events

    put 'unattend' => 'events#unattend', as: 'unattend'
    put 'undo_check_in' => 'events#undo_check_in', as: 'undo_check_in'

    devise_scope :user do
      post 'create_attendee' => 'users#create_attendee', as: 'create_attendee'
    end
  end

  match "*path", to: redirect('/'), via: :all, alert: 'Page does not exist!'
end




