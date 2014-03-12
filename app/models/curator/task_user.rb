class Curator::TaskUser < ActiveRecord::Base
  self.table_name = 'curator_task_user'

  has_many :tasks, class_name: Curator::Task
  has_many :users
end