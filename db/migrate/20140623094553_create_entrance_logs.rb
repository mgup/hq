class CreateEntranceLogs < ActiveRecord::Migration
  def change
    create_table :entrance_logs do |t|
      t.belongs_to :user
      t.belongs_to :entrant
      t.string :comment

      t.timestamps
    end
  end
end
