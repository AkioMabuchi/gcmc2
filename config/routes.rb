Rails.application.routes.draw do
  root "home#top"

  get "terms", to: "home#terms", as: "terms"
  get "privacy", to: "home#privacy", as: "privacy"

  devise_for :users, skip: [:sessions, :registrations],
             path: "",
             controllers: {
               confirmations: "users/confirmations",
               passwords: "users/passwords",
               registrations: "users/registrations",
               sessions: "users/sessions",
               omniauth_callbacks: "users/omniauth_callbacks"
             }

  devise_scope :user do
    get "login", to: "users/sessions#new", as: "new_user_session"
    post "login", to: "users/sessions#create", as: "user_session"
    delete "logout", to: "users/sessions#destroy", as: "destroy_user_session"
    get "signup", to: "users/registrations#new", as: "new_user_registration"
    post "signup", to: "users/registrations#create", as: "create_user_registration"
    get "settings", to: "users/registrations#edit", as: "edit_user_registration"
    patch "settings", to: "users/registrations#update", as: "user_registration"
    get "settings/:mode", to: "users/registrations#edit", constraints: { mode: %w[email password notification sns destroy] }
    get "settings/email", as: "edit_email_user_registration"
    patch "settings/email", to: "users/registrations#update", as: "email_user_registration"
    get "settings/password", as: "edit_password_user_registration"
    patch "settings/password", to: "users/registrations#update", as: "password_user_registration"
    get "settings/notification", as: "edit_notification_user_registration"
    patch "settings/notification", to: "users/registrations#update", as: "notification_user_registration"
    get "settings/sns", as: "edit_sns_user_registration"
    patch "settings/sns", to: "users/registrations#update", as: "sns_user_registration"
    get "settings/destroy", as: "edit_destroy_user_registration"
    delete "settings/destroy", to: "users/registrations#destroy", as: "destroy_user_registration"
  end

  resources :users, only: [:index, :show]
  resources :teams, except: [:new], path_names: { edit: :settings } do
    member do
      get :tags_edit, path: "settings/tags"
      get :environments_edit, path: "settings/environments"
      get :urls_edit, path: "settings/urls"
      get :wants_edit, path: "settings/wants"
      get :dissolution, path: "settings/dissolution"
      patch :tags_update, path: "tags"
      patch :environments_update, path: "environments"
    end
  end

  resource :twitters, only: [:destroy], path: "disconnect/twitter"
  resource :githubs, only: [:destroy], path: "disconnect/github"
  resources :setting_skills, except: [:show, :new, :edit], path: "settings/skills"
  resources :setting_portfolios, except: [:show, :new, :edit], path: "settings/portfolios"
  resources :setting_invitations, except: [:show, :new, :edit, :update], path: "settings/invitations"
  resources :wanted_positions, only: [:create, :update, :destroy], path: "settings/:permalink/wants"
  resources :team_urls, only: [:create, :update, :destroy], path: "teams/:permalink/settings/urls"
  resources :join_requests, only: [:index, :create, :destroy], path: "teams/:permalink/join" do
    member do
      post :accept
      post :reject
    end
  end
  resources :invitations, only: [:index, :create, :destroy] do
    member do
      post :accept
      post :reject
    end
  end
  resources :portfolios, only: [:show]
  resources :contact_messages, only: [:index, :create], path: "contact"
  resources :messages, only: [:index, :create] do
    collection do
      match :room, path: "rooms/:permalink", via: [:get, :post]
    end
    member do
      patch :read
    end
  end
  get "new-team", to: "teams#new", as: "new_team"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
