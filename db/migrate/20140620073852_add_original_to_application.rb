class AddOriginalToApplication < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.boolean :original, default: false
    end
  end
end
