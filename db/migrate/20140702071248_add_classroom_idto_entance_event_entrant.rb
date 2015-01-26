class AddClassroomIdtoEntanceEventEntrant < ActiveRecord::Migration
  def change
    change_table :entrance_event_entrants do |t|
      t.references :classroom
    end
  end
end
