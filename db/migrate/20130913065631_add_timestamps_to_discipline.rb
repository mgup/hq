class AddTimestampsToDiscipline < ActiveRecord::Migration
  def change
    change_table :subject do |t|
      t.timestamps
    end
  end
end
