class Office::TemplateStudentStatus < ActiveRecord::Base
  self.table_name = 'template_student_group_statuses'

  belongs_to :template, class_name: 'Office::OrderTemplate', foreign_key: :template_id, primary_key: :template_id
  belongs_to :status, class_name: 'EducationStatus', foreign_key: :education_status_id

end