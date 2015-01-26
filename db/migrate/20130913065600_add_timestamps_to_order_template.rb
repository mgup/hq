class AddTimestampsToOrderTemplate < ActiveRecord::Migration
  def change
    change_table :template do |t|
      t.timestamps
    end
  end
end
