class CreateEventDateClaimTable < ActiveRecord::Migration
  def change
    create_table :event_date_claim do |t|
      t.string         :fname
      t.string         :iname
      t.string         :oname
      t.string         :phone
      t.string         :email

      t.timestamps

      t.references :group, index: true
      t.references :event, index: true
    end
  end
end
