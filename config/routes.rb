Rails.application.routes.draw do
  get 'billing/edit'

  get 'billing/update_card'


  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/import'

  get 'billing/update_contact'

  root 'static_pages#home'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :user do 
    resources :users do

      collection { post :import }
      user do
        get 'dues', to: "billing#overview"
        scope 'dues', as: :billing do
          resources :subscriptions do
            post 'cancel'
            get 'renew'
            put 'reactivate'
          end
          get 'enroll', to: "billing#enroll", as: :enroll
          get 'edit', to: "billing#edit", as: :edit
          post 'subscribe', to: "billing#subscribe", as: :subscribe
          put 'update_card', to: "billing#update_card", as: :update_card
          put 'update_contact', to: "billing#update_contact", as: :update_contact
        end
        post 'check_in'
      end
    end

    resources :events do
      resources :users do
      end
      collection do
        post :import_events, as: 'import'
        post :import_attendances, as: 'import_attendances'
      end
    end

    put 'unattend' => 'events#unattend', as: 'unattend'
    put 'check_in' => 'events#check_in', as: 'check_in'
    put 'undo_check_in' => 'events#undo_check_in', as: 'undo_check_in'

    devise_scope :user do
      post 'create_attendee' => 'users#create_attendee', as: 'create_attendee'
    end
  end
end




