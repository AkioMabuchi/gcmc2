class WantedPosition < ApplicationRecord
  belongs_to :team
  belongs_to :position_name, foreign_key: :name_id, optional: true

  validates :amount,
            presence: {message: "入力してください"},
            numericality: {greater_than: 0, less_than: 100, message: "1~99の間で入力してください"}
end
