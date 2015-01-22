class CreateEntranceApplications < ActiveRecord::Migration
  def change
    create_table :entrance_applications do |t|
      t.string :number
      t.references :entrant
      t.date :registration_date
      t.date :last_deny_date
      t.boolean :need_hostel
      t.references :status
      t.text :comment

      t.timestamps
    end
  end
end
