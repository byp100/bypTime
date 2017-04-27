Rails.application.routes.draw do


  get 'static_pages/home'
  get 'static_pages/import'

  scope 'webhooks', as: :messages do
    post 'chargebee_event', to: "webhooks#chargebee_event", as: :chargebee_event
  end


  root 'static_pages#home'

  get 'static_pages/home', as: :static_pages_about

  get 'events/:event_id/join', to: "users#new", as: :new_event_user
  post 'events/:event_id/users', to: "users#create", as: :event_users

  post 'users/create_with_access_code', to: 'users#create_with_access_code', as: 'create_with_access_code'

  devise_for :users

  #devise_for :admin_users, ActiveAdmin::Devise.config
  #ActiveAdmin.routes(self)

  authenticated :user do
    get "dashboard", to: "users#show", as: :dashboard
    scope 'dashboard' do
      get 'dues', to: "billing#overview"
      scope 'dues', as: :billing do
        resources :subscriptions do
          post 'cancel'
          get 'renew'
          put 'reactivate'
        end
        get 'pay', to: "billing#pending_invoices", as: :pending_invoices
        post 'pay', to: "billing#close_invoice", as: :close_invoice
        get 'enroll', to: "billing#enroll", as: :enroll
        get 'edit', to: "billing#edit", as: :edit
        post 'subscribe', to: "billing#subscribe", as: :subscribe
        put 'update_card', to: "billing#update_card", as: :update_card
        put 'update_contact', to: "billing#update_contact", as: :update_contact
      end
    end

    resources :users do
      collection { post :import }
    end

    get 'admin', to: "admin#dashboard", as: :admin_dashboard
    scope 'admin', as: :admin do
      get 'users', to: "users#index", as: :users
      get 'users/:id/edit', to: "users#edit", as: :edit_user
      get 'users/:id', to: "users#show", as: :user
      post 'users/:user_id/check_in', to: "users#check_in", as: :user_check_in
      post 'users/import', to: "users#import", as: :user_import
      get "events", to: "events#all", as: :events
      get "events/:id", to: "events#show", as: :event

    end

    resources :events do
      collection do
        post :import_events, as: 'import'
        post :import_attendances, as: 'import_attendances'
      end
    end

    put 'unattend' => 'events#unattend', as: 'unattend'
    put 'undo_check_in' => 'events#undo_check_in', as: 'undo_check_in'

    devise_scope :user do
      post 'create_attendee' => 'users#create_attendee', as: 'create_attendee'
    end
  end
end




