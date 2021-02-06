# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @hoge = "Akio Mabuchi"
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def edit_sns
  end


  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  def disconnect_twitter
    current_user.update_attributes(
        {
            twitter_uid: nil,
            twitter_url: nil,
            is_published_twitter: nil
        }
    )
    current_user.save!

    redirect_to edit_sns_user_registration_path, notice: "Twitterとの連携を解除しました"
  end

  def disconnect_github
    current_user.update_attributes(
        {
            github_uid: nil,
            github_url: nil,
            is_published_github: nil
        }
    )
    current_user.save!

    redirect_to edit_sns_user_registration_path, notice: "GitHubとの連携を解除しました"
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def update_resource(resource, params)
    resource.update_without_current_password params
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
