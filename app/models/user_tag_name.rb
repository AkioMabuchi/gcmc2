class UserTagName < ApplicationRecord
  validates :name, presence: true
  validates :sort_number, presence: true, uniqueness:{case_sensitive: true}

  has_many :user_tags, foreign_key: :name_id, dependent: :destroy
end
