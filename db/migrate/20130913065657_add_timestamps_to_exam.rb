class AddTimestampsToExam < ActiveRecord::Migration
  def change
    change_table :exam do |t|
      t.timestamps
    end
  end
end
