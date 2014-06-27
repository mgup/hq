class Entrance::DocumentMovement < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :from_application, class_name: 'Entrance::Application',
             foreign_key: :from_application_id

  belongs_to :to_application, class_name: 'Entrance::Application',
             foreign_key: :to_application_id

  def apply_movement
    applications = from_application.entrant.applications


  end
end
