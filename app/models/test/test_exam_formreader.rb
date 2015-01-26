class ExamFormreader < ActiveRecord::Base
  self.table_name = 'exam_formreader'

  alias_attribute :id,       :exam_formreader_id
  alias_attribute :parsed,   :exam_formreader_parsed

end