class AddLettersToDirections < ActiveRecord::Migration
  def change
    change_table :directions do |t|
      t.string :letters
    end
  end
end
