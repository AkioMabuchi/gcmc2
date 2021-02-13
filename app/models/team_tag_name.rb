class TeamTagName < ApplicationRecord
  validates :name, presence: true
  validates :sort_number, presence: true, uniqueness:{case_sensitive: true}

  has_many :team_tags, foreign_key: :name_id, dependent: :destroy
end
