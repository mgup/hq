class Study::Vkr < ActiveRecord::Base
  self.table_name = 'study_vkrs'

  belongs_to :student
  has_many :materials, class_name: 'Study::VkrMaterial'
end
