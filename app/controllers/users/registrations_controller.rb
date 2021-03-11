# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      if resource.errors.messages[:permalink]
        flash[:permalink_warning] = resource.errors.messages[:permalink][0]
      end
      if resource.errors.messages[:name]
        flash[:name_warning] = resource.errors.messages[:name][0]
      end
      if resource.errors.messages[:email]
        flash[:email_warning] = resource.errors.messages[:email][0]
      end
      if resource.errors.messages[:password]
        flash[:password_warning] = resource.errors.messages[:password][0]
      end
      if resource.errors.messages[:password_confirmation]
        flash[:password_confirmation_warning] = resource.errors.messages[:password_confirmation][0]
      end
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit

  def edit
    if params[:mode]
      case params[:mode]
      when "email" then
        @mode = "email"
      when "password" then
        @mode = "password"
      when "notification" then
        @mode = "notification"
      when "sns" then
        @mode = "sns"
      when "destroy" then
        @mode = "destroy"
      else
        raise StandardError
      end
    else
      @mode = "profile"
    end

    super
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      case params[:mode]
      when "profile" then
        redirect_to edit_user_registration_path, notice: "プロフィールを更新しました"
      when "email" then
        redirect_to edit_email_user_registration_path, notice: "メールアドレスを更新するための確認を行ってください"
      when "password" then
        redirect_to edit_password_user_registration_path, notice: "パスワードを更新しました"
      when "notification" then
        redirect_to edit_notification_user_registration_path, notice: "通知設定を更新しました"
      when "sns" then
        redirect_to edit_sns_user_registration_path, notice: "SNS設定を更新しました"
      else
        raise StandardError
      end

    else
      if resource.errors.messages[:permalink]
        flash[:permalink_warning] = resource.errors.messages[:permalink][0]
      end

      if resource.errors.messages[:email]
        flash[:email_warning] = resource.errors.messages[:email][0]
      end

      clean_up_passwords resource
      set_minimum_password_length

      case params[:mode]
      when "profile" then
        redirect_to edit_user_registration_path
      when "email" then
        redirect_to edit_email_user_registration_path
      when "sns" then
        redirect_to edit_sns_user_registration_path
      else
        raise StandardError
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

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
  def configure_sign_up_params
    added_attrs = [
      :permalink,
      :name,
      :email,
      :password,
      :password_confirmations
    ]

    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs

    build_resource(sign_up_params)

    unless verify_recaptcha(model: resource)
      redirect_to new_user_registration_path, alert: "reCAPTCHA認証を行ってください"
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    added_attrs = [
      [
        :permalink,
        :name,
        :image,
        :description,
        :location,
        :birth,
        :is_birth_published,
        :url
      ],
      user_tag_name_ids: [],
      twitter_attributes: [
        :id,
        :uid,
        :url,
        :is_published_url
      ],
      github_attributes: [
        :id,
        :uid,
        :url,
        :is_published_url
      ]
    ]

    devise_parameter_sanitizer.permit :account_update, keys: added_attrs

    if params[:mode] == "email"
      if params[:current_email] != resource.email
        flash[:current_email_warning] = "メールアドレスが間違っています"
        redirect_to edit_email_user_registration_path
      elsif params[:user][:email] == resource.email
        flash[:email_warning] = "別のメールアドレスを入力してください"
        redirect_to edit_email_user_registration_path
      end
    end

    if params[:mode] == "password"
      if !resource.valid_password? params[:current_password]
        flash[:current_password_warning] = "パスワードが間違っています"
        redirect_to edit_password_user_registration_path
      elsif !(8..32).cover? params[:user][:password].length
        flash[:password_warning] = "8字以上、32字以内で入力してください"
        redirect_to edit_password_user_registration_path
      elsif params[:user][:password] != params[:user][:password_confirmation]
        flash[:password_confirmation_warning] = "もう一度入力してください"
        redirect_to edit_password_user_registration_path
      end
    end
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  # end
end
