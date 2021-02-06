# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def twitter
    auth_hash = request.env["omniauth.auth"]
    if auth_hash[:provider] == "twitter"
      user = User.find_by(twitter_uid: auth_hash[:uid])
      if user_signed_in?
        if user
          redirect_to edit_sns_user_registration_path, alert: "このTwitterアカウントは既に使用されています"
        else
          current_user.connect_twitter auth_hash[:uid], auth_hash[:info][:urls][:Twitter]
          redirect_to edit_sns_user_registration_path, notice: "Twitterと連携しました"
        end
      else
        if user
          sign_in user
          redirect_to root_path, notice: "ようこそ、#{user.name}さん"
        else
          redirect_to new_user_session_path, alert: "このTwitterアカウントは連携されていません"
        end

      end
    else
      raise StandardError
    end
  end

  def github
    auth_hash = request.env["omniauth.auth"]
    if auth_hash[:provider] == "github"
      user = User.find_by(github_uid: auth_hash[:uid])
      if user_signed_in?
        if user
          redirect_to edit_sns_user_registration_path, alert: "このGitHubアカウントは既に使用されています"
        else
          current_user.connect_github auth_hash[:uid], auth_hash[:info][:urls][:GitHub]
          redirect_to edit_sns_user_registration_path, notice: "GitHubと連携しました"
        end
      else
        if user
          sign_in user
          redirect_to root_path, notice: "ようこそ、#{user.name}さん"
        else
          redirect_to new_user_session_path, alert: "このGitHubアカウントは連携されていません"
        end
      end
    else
      raise StandardError
    end
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
