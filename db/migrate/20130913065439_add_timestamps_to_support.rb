class AddTimestampsToSupport < ActiveRecord::Migration
  def change
    change_table :support do |t|
      t.timestamps
    end
  end
end
