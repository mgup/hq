class Entrance::UseCheckResult < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :use_check, class_name: Entrance::UseCheck, foreign_key: :use_check_id
  belongs_to :exam_result, class_name: Entrance::ExamResult
end