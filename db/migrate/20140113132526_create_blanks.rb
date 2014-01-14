class CreateBlanks < ActiveRecord::Migration
  def change
    create_table :blanks do |t|
      t.integer :type
      t.integer :number
      t.text :details

      t.timestamps
    end
  end
end
