class Study::Gek < ActiveRecord::Base
  self.table_name = 'study_geks'

  belongs_to :position
  belongs_to :group
  has_one :user, through: :position
end
