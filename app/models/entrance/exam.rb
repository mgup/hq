class Entrance::Exam < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: 'Entrance::Campaign'
  belongs_to :use_subject, class_name: 'Use::Subject'
end
