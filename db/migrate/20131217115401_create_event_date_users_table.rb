class CreateEventDateUsersTable < ActiveRecord::Migration
  def change
    create_table :visitor_event_date do |t|
      t.references :event_date, index: true
      t.references :visitor, polymorphic: true
    end
  end
end
