class TeamTag < ApplicationRecord
  belongs_to :team
  belongs_to :team_tag_name, foreign_key: :name_id
end
