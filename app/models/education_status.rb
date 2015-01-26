class EducationStatus < ActiveRecord::Base
  has_many :template_statuses, class_name: 'Office::TemplateStudentStatus', foreign_key: :education_status_id
  has_many :templates, class_name: 'Office::OrderTemplate', through: :template_statuses
end