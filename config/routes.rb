Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/import'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :user do 
    resources :users do
        collection { post :import }
        post 'check_in'
    end

    resources :events do
      resources :users do
      end
      collection do
        post :import_events, as: 'import'
        post :import_attendances, as: 'import_attendances'
      end
    end

    root 'static_pages#home'
    put 'unattend' => 'events#unattend', as: 'unattend'
    put 'check_in' => 'events#check_in', as: 'check_in'
    put 'undo_check_in' => 'events#undo_check_in', as: 'undo_check_in'

    devise_scope :user do
      post 'create_attendee' => 'users#create_attendee', as: 'create_attendee'
    end
  end
end




