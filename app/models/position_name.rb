class PositionName < ApplicationRecord
  validates :name, presence: true
  validates :sort_number, presence: true, uniqueness: {case_sensitive: true}

  has_many :positions, foreign_key: :name_id, dependent: :destroy
  has_many :wanted_positions, foreign_key: :name_id, dependent: :destroy
  has_many :join_requests, dependent: :destroy
  has_many :members, dependent: :destroy
end
