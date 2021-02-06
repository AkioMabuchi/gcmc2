Rails.application.routes.draw do
  root "home#top"

  resources :users
  devise_for :users,
             path: "",
             path_names: {
                 sign_up: "/signup",
                 sign_in: "/login",
                 edit: "/settings"
             },
             controllers:{
                 registrations: "users/registrations",
                 sessions: "users/sessions",
                 omniauth_callbacks: "users/omniauth_callbacks"
             }

  devise_scope :user do
    get "settings/sns", to: "devise/registrations#edit_sns", as: "edit_sns_user_registration"
    put "disconnect/twitter", to: "users/registrations#disconnect_twitter", as: "disconnect_twitter"
    put "disconnect/github", to: "users/registrations#disconnect_github", as: "disconnect_github"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
