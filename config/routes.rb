Rails.application.routes.draw do
  root "home#top"

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
    put "disconnect/twitter", to: "users/registrations#disconnect_twitter", as: "disconnect_twitter"
    put "disconnect/github", to: "users/registrations#disconnect_github", as: "disconnect_github"
  end

  resources :setting_skills, except: [:show, :new, :edit], path: "settings/skills"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
