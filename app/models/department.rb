class Department < ActiveRecord::Base
  self.table_name = 'department'

  alias_attribute :id,           :department_id
  alias_attribute :name,         :department_name
  alias_attribute :abbreviation, :department_sname
  alias_attribute :parent,       :department_parent
  alias_attribute :role,         :department_role

  # Подчинённые подразделения текущего подразделения.
  has_many :subdepartments, class_name: Department,
           foreign_key: :department_parent

  # Главное подразделение текущего подразделение.
  belongs_to :main_department, class_name: Department,
             foreign_key: :department_parent

  scope :only_main, -> { where(department_parent: nil) }

  scope :faculties, -> { where(department_role: :faculty) }
end