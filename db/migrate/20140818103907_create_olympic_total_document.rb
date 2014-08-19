class CreateOlympicTotalDocument < ActiveRecord::Migration
  def change
    create_table :olympic_total_documents do |t|
      t.boolean    :original, default: true
      t.string     :series
      t.string     :number
      t.integer    :diploma_type_id
      t.belongs_to :entrance_benefit
    end
  end
end
