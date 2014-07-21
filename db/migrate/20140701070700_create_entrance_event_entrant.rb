class CreateEntranceEventEntrant < ActiveRecord::Migration
  def change
    create_table :entrance_event_entrants do |t|
      t.references :entrance_event, null: false
      t.references :entrance_entrant, null: false
    end
  end
end
