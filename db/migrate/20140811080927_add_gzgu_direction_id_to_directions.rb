class AddGzguDirectionIdToDirections < ActiveRecord::Migration
  def change
    change_table :directions do |t|
      t.integer :gzgu
    end
  end
end
