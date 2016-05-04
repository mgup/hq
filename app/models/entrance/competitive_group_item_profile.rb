class Entrance::CompetitiveGroupItemProfile < ActiveRecord::Base
  belongs_to :competitive_group_item, class_name: Entrance::CompetitiveGroupItem,
             foreign_key: :item_id
  belongs_to :profile, class_name: Speciality, foreign_key: :profile_id,
              primary_key: :speciality_id
end
