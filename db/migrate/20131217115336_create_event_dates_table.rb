class CreateEventDatesTable < ActiveRecord::Migration
  def change
    create_table :event_date do |t|
      t.date          :date
      t.time          :time_start
      t.time          :time_end
      t.integer       :max_visitors
      t.timestamps

      t.references :event, index: true
    end
  end
end
