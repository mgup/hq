class CheckpointMark < ActiveRecord::Base
  self.table_name = 'checkpoint_mark'

  alias_attribute :id,        :checkpoint_mark_id
  alias_attribute :mark,      :checkpoint_mark_mark

  belongs_to :student, primary_key: :student_id, foreign_key: :checkpoint_mark_student
  belongs_to :checkpoint, primary_key: :checkpoint_id, foreign_key: :checkpoint_mark_checkpoint

end