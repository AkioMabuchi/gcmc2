class ContactMailer < ApplicationMailer
  def contact_message(contact)
    @email = contact.email
    @title = contact.title
    @message = contact.message
    mail(subject: "「#{@email}」よりお問い合わせ", to: Rails.application.credentials.email[:admin]) do |format|
      format.html
    end
  end
end
