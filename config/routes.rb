Rails.application.routes.draw do
  root "home#index"

  devise_for :users,
             path: "",
             path_names: {
                 sign_up: "/signup",
                 sign_in: "/login",
                 edit: "/settings"
             },
             controllers: {
                 registrations: "users/registrations",
                 sessions: "users/sessions",
                 omniauth_callbacks: "users/omniauth_callbacks"
             }

  devise_scope :user do
    get "settings/:mode", to: "users/registrations#edit", constraints: {mode: %w[email password sns destroy]}
    get "settings/email", as: "edit_email_user_registration"
    get "settings/password", as: "edit_password_user_registration"
    get "settings/sns", as: "edit_sns_user_registration"
    get "settings/destroy", as: "edit_destroy_user_registration"
  end

  resources :users, only: [:index, :show]
  resources :teams, except: [:new], path_names: {edit: :settings} do
    member do
      get :tags_edit, path: "settings/tags"
      get :environments_edit, path: "settings/environments"
      get :wants_edit, path: "settings/wants"
      get :publishing_edit, path: "settings/publishing"
      get :dissolution, path: "settings/dissolution"
      patch :tags_update, path: "tags"
      patch :publishing_update, path: "publishing"
      patch :environments_update, path: "environments"
    end
  end


  resource :twitters, only: [:destroy], path: "disconnect/twitter"
  resource :githubs, only: [:destroy], path: "disconnect/github"
  resources :setting_skills, except: [:show, :new, :edit], path: "settings/skills"
  resources :setting_portfolios, except: [:new, :edit], path: "settings/portfolios"
  resources :setting_invitations, except: [:show, :new, :edit, :update], path: "settings/invitations"
  resources :wanted_positions, only: [:create, :update, :destroy], path: "settings/:permalink/wants"

  get "new-team", to: "teams#new", as: "new_team"

  post "test-data", to: "users#test_data"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
