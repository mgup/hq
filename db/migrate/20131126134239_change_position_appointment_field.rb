class ChangePositionAppointmentField < ActiveRecord::Migration
  def change
    rename_column :acl_position, :acl_position_appointment, :started_at
  end
end
