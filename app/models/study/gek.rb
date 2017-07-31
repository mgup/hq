class Study::Gek < ActiveRecord::Base
  self.table_name = 'study_geks'

  belongs_to :position
  belongs_to :group
  has_one :user, through: :position

  default_scope { where(study_year: Study::Discipline::CURRENT_STUDY_YEAR) }
end
