class CreateOlympicDocument < ActiveRecord::Migration
  def change
    create_table :olympic_documents do |t|
      t.boolean    :original, default: true
      t.string     :series
      t.string     :number
      t.date       :date
      t.integer    :diploma_type_id
      t.integer    :olympic_id
      t.integer    :level_id
      t.belongs_to :entrance_benefit
    end
  end
end
