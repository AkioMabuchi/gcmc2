# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def twitter
    auth_hash = request.env["omniauth.auth"]
    if auth_hash[:provider] == "twitter"
      if user_signed_in?
        new_twitter = Twitter.new(
            user_id: current_user.id,
            uid: auth_hash[:uid],
            url: auth_hash[:info][:urls][:Twitter]
        )
        if new_twitter.save
          redirect_to edit_sns_user_registration_path, notice: "Twitterと連携しました"
        else
          redirect_to edit_sns_user_registration_path, alert: "このTwitterアカウントは既に使用されています"
        end
      else
        twitter_record = Twitter.find_by(uid: auth_hash[:uid])
        if twitter_record
          user = twitter_record.user
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
      if user_signed_in?
        new_github = Github.new(
            user_id: current_user.id,
            uid: auth_hash[:uid],
            url: auth_hash[:info][:urls][:GitHub]
        )
        if new_github.save
          redirect_to edit_sns_user_registration_path, notice: "GitHubと連携しました"
        else
          redirect_to edit_sns_user_registration_path, alert: "このGitHubアカウントは既に使用されています"
        end
      else
        github_record = Github.find_by(uid: auth_hash[:uid])
        if github_record
          user = github_record.user
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
  def passthru
    super
  end

  # GET|POST /users/auth/twitter/callback
  def failure
    super
  end

  # protected

  # The path used when OmniAuth fails
  def after_omniauth_failure_path_for(scope)
    super(scope)
  end
end
