class Portfolio < ApplicationRecord
  mount_uploader :image, PortfolioImageUploader

  belongs_to :user

  validates :name, presence: {message: "入力してください"}
end
