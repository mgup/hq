class Entrance::EduDocument < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :document_type, class_name: 'Entrance::DocumentType'
end
