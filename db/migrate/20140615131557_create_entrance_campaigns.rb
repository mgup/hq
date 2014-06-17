class CreateEntranceCampaigns < ActiveRecord::Migration
  def change
    create_table :entrance_campaigns do |t|
      t.string :name, null: false
      t.integer :start_year, null: false
      t.integer :end_year, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
