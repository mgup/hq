class Study::ExamFormreader < ActiveRecord::Base
  self.table_name = 'exam_formreader'

  alias_attribute :id,       :exam_formreader_id
  alias_attribute :parsed,   :exam_formreader_parsed

  belongs_to :exam, -> { where(exam_type: [Study::Exam::TYPE_TEST, Study::Exam::TYPE_GRADED_TEST, Study::Exam::TYPE_EXAMINATION]) },
                        class_name: Study::Exam, foreign_key: :DocNumber
end