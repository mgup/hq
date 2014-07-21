class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.string  :code
      t.string  :new_code
      t.string  :name
      t.integer :qualification_code
      t.string  :ugs_code
      t.string  :ugs_name
      t.string  :period
    end
  end
end
