class MessagesController < ApplicationController
  before_action :login_user_only, only: [:index]
  before_action :self_user_forbidden, only: [:room]

  def index
    sender_user_ids = Message.where(receiver_user_id: current_user.id).select(:sender_user_id).distinct.pluck(:sender_user_id)
    @sender_users = User.where(id: sender_user_ids)
  end

  def show

  end

  def room
    sender_user = current_user
    receiver_user = User.friendly.find(params[:permalink])

    unread_messages = Message.where(receiver_user_id: sender_user.id, is_read: false)
    unread_messages.update_all(is_read: true)

    raw_messages = Message.where(sender_user_id: sender_user.id, receiver_user_id: receiver_user.id).or(Message.where(sender_user_id: receiver_user.id, receiver_user_id: sender_user.id)).order(updated_at: :desc)

    messages = []

    raw_messages.each do |raw_message|
      message = {
        image: raw_message.sender_user.image.url,
        name: raw_message.sender_user.name,
        date: raw_message.updated_at.strftime("%Y-%m-%d %H:%M"),
        content: raw_message.content
      }

      messages.append message
    end

    @react_info = {
      authenticityToken: form_authenticity_token,
      senderUser: {
        id: sender_user.id
      },
      receiverUser: {
        id: receiver_user.id,
        permalink: receiver_user.permalink,
        image: receiver_user.image.url,
        name: receiver_user.name
      },
      messages: messages
    }
  end

  def create
    message = Message.new(message_params)

    if message.save
      sender_message = {
        id: message.id,
        userId: message.sender_user.id,
        image: message.sender_user.image.url,
        name: message.sender_user.name,
        date: message.updated_at.strftime("%Y-%m-%d %H:%M"),
        content: message.content
      }
      ActionCable.server.broadcast "message_channel_#{message.receiver_user_id}", message: sender_message.as_json

      render json: {
        status: true,
        message: sender_message
      }
    else
      render json: {
        status: false,
        messages: {
          content: message.errors.messages[:content][0]
        }
      }
    end
  end

  def read
    message = Message.find(params[:id])
    message.update(is_read: true)

    if message.save
      render json: {
        status: true
      }
    else
      render json: {
        status: false
      }
    end
  end

  private

  def login_user_only
    unless user_signed_in?
      raise Forbidden
    end
  end

  def self_user_forbidden
    if user_signed_in?
      if params[:permalink] == current_user.permalink
        raise Forbidden
      end
    else
      raise Forbidden
    end
  end
  def message_params
    params.require(:message).permit(:sender_user_id, :receiver_user_id, :content)
  end
end
