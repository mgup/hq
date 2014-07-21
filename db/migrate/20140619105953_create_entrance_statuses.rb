class CreateEntranceStatuses < ActiveRecord::Migration
  def change
    create_table :entrance_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
