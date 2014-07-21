class Entrance::MinScore < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: Entrance::Campaign
  belongs_to :education_source, class_name: Entrance::Campaign
  belongs_to :exam, class_name: Entrance::Exam, foreign_key: :entrance_exam_id
  belongs_to :direction

  scope :by_direction, -> direction { where(direction_id: direction.id) }
  scope :by_exam, -> exam { where(entrance_exam_id: exam.id) }
  scope :budget, -> { where(education_source_id: 14) }
  scope :paid, -> { where(education_source_id: 15) }

end