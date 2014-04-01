class CreateHostelReport < ActiveRecord::Migration
  def change
    create_table :hostel_report do |t|
      t.date          :date
      t.time          :time

      t.timestamps

      t.references :user, index: true
      t.references :flat, index: true
    end
  end
end
