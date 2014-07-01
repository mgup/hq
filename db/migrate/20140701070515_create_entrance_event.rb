class CreateEntranceEvent < ActiveRecord::Migration
  def change
    create_table :entrance_events do |t|
      t.string :name
      t.text   :description
      t.date   :date
    end
  end
end
