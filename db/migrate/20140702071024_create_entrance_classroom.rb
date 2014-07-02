class CreateEntranceClassroom < ActiveRecord::Migration
  def change
    create_table :entrance_classrooms do |t|
      t.string :number
      t.integer :sits
    end
  end
end
