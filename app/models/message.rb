class Message < ApplicationRecord
  validates :content, presence: {message: "入力してください"}, length: {maximum: 240, too_long: "240字以内で入力してください"}
  validates :sender_user_id, presence: true
  validates :receiver_user_id, presence: true

  belongs_to :sender_user, class_name: "User", foreign_key: :sender_user_id
  belongs_to :receiver_user, class_name: "User", foreign_key: :receiver_user_id
end
