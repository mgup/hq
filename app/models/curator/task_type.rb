class Curator::TaskType < ActiveRecord::Base
  self.table_name = 'curator_task_type'

  HOSTEL_TYPE = 4

  has_many :tasks, class_name: Curator::Task

  validates :name, presence: true
end