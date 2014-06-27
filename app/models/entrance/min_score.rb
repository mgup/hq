class Entrance::MinScore < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: Entrance::Campaign
  belongs_to :education_source, class_name: Entrance::Campaign
  belongs_to :subject, class_name: Use::Subject, foreign_key: :use_subject_id

end