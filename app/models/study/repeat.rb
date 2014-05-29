class Study::Repeat < ActiveRecord::Base
  TYPE_EARLY      = 1
  TYPE_FIRST      = 2
  TYPE_SECOND     = 3
  TYPE_COMMISSION = 4
  TYPE_RESPECTFUL = 5

  self.table_name = 'exam'

  alias_attribute :id,   :exam_id
  alias_attribute :date, :exam_date
  alias_attribute :type, :exam_repeat

  belongs_to :exam, class_name: 'Study::Exam',
             primary_key: :exam_id, foreign_key: :exam_parent
end