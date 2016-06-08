class Study::VkrMaterial < ActiveRecord::Base
  self.table_name = 'study_vkr_materials'

  belongs_to :vkr, class_name: 'Study::Vkr'

  has_attached_file :data
  validates_attachment_presence :data
  validates_attachment_size :data, less_than: 50.megabytes
  do_not_validate_attachment_file_type :data
end
