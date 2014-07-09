class CreateEntranseUseCheck < ActiveRecord::Migration
  def change
    create_table :entrance_use_checks do |t|
      t.text       :number
      t.integer    :year
      t.date       :date
      t.belongs_to :entrant

      t.timestamps
    end
  end
end
