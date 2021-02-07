class Skill < ApplicationRecord
  belongs_to :user

  validates :name, presence: {message: "入力してください"}
  validates :level, presence: {message: "入力してください"}
end
