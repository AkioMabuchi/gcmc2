class ContactMessagesController < ApplicationController
  before_action :confirm_recaptcha, only: [:create]

  def index
    @contact_message = ContactMessage.new
    if user_signed_in?
      @contact_message.email = current_user.email
    end
  end

  def create
    contact_message = ContactMessage.new(contact_message_params)

    if contact_message.save
      ContactMailer.contact_message(contact_message).deliver_now
      redirect_to contact_messages_path, notice: "お問い合わせありがとうございます"
    else
      if contact_message.errors.messages[:email]
        flash[:email_warning] = contact_message.errors.messages[:email][0]
      end

      if contact_message.errors.messages[:title]
        flash[:title_warning] = contact_message.errors.messages[:title][0]
      end

      if contact_message.errors.messages[:message]
        flash[:message_warning] = contact_message.errors.messages[:message][0]
      end

      redirect_to contact_messages_path
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:email, :title, :message)
  end

  def confirm_recaptcha
    contact_message = ContactMessage.new(contact_message_params)
    unless verify_recaptcha(model: contact_message)
      redirect_to contact_messages_path, alert: "reCAPTCHA認証を行ってください"
    end
  end
end
