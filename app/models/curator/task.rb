class Curator::Task < ActiveRecord::Base
  self.table_name = 'curator_task'

  has_many :task_users, class_name: Curator::TaskUser
  has_many :users, through: :task_users

  belongs_to :type, class_name: Curator::TaskType
end