class Entrance::Exam < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  enum form: { simple: 1, profile: 3, creative: 2 }

  belongs_to :campaign, class_name: 'Entrance::Campaign'
  belongs_to :use_subject, class_name: 'Use::Subject'

  has_many :exam_results, class_name: Entrance::ExamResult, foreign_key: :exam_id
  accepts_nested_attributes_for :exam_results

  has_many :test_items, class_name: Entrance::TestItem, foreign_key: :exam_id

  default_scope do
    order(:name)
  end
end
