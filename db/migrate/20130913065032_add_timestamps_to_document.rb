class AddTimestampsToDocument < ActiveRecord::Migration
  def change
    change_table :document do |t|
      t.timestamps
    end
  end
end
