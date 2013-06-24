class Checkpoint < ActiveRecord::Base
  self.table_name = 'checkpoint'

  alias_attribute :id,       :checkpoint_id
  alias_attribute :name,     :checkpoint_name
  alias_attribute :type,     :checkpoint_type
  alias_attribute :date,     :checkpoint_date
  alias_attribute :min,      :checkpoint_min
  alias_attribute :max,      :checkpoint_max
  alias_attribute :closed,   :checkpoint_closed

  belongs_to :subject, primary_key: :subject_id, foreign_key: :checkpoint_subject

  has_many :checkpoint_marks, foreign_key: :checkpoint_mark_checkpoint
end