class ContactMessage < ApplicationRecord
  validates :email, presence: {message: "入力してください"}
  validates :title, presence: {message: "入力してください"}
  validates :message, presence: {message: "入力してください"}
end
