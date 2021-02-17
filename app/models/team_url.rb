class TeamUrl < ApplicationRecord
  belongs_to :team
  validates :name, presence: {message: "入力してくだしい"}
  validates :url, presence: {message: "入力してください"}
end
