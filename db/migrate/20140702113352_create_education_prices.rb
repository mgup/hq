class CreateEducationPrices < ActiveRecord::Migration
  def change
    create_table :education_prices do |t|
      t.belongs_to :direction
      t.belongs_to :education_form
      t.integer :entrance_year
      t.integer :course
      t.decimal :price, precision: 9, scale: 2

      t.timestamps
    end
  end
end
