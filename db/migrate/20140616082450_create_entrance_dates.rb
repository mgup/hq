class CreateEntranceDates < ActiveRecord::Migration
  def change
    create_table :entrance_dates do |t|
      t.references :campaign, null: false

      t.integer :course, null: false, default: 1
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.date :order_date, null: false

      t.references :education_form, null: false
      t.references :education_level, null: false
      t.references :education_source, null: false

      t.integer :stage

      t.timestamps
    end
  end
end
