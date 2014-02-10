class Graduate < ActiveRecord::Base
  belongs_to :group
  has_many :graduate_subjects, dependent: :destroy

  accepts_nested_attributes_for :graduate_subjects, allow_destroy: true

end
