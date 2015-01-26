class Rating2013 < ActiveRecord::Migration
  def change
    create_table :rating do |t|
      t.integer :year
      t.references :user
      t.decimal :rating, precision: 10, scale: 3

      t.timestamps
    end
  end
end
