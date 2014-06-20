class CreateCommonBenefitItemOlympicDiplomType < ActiveRecord::Migration
  def change
    create_table :common_benefit_item_olympic_diplom_types do |t|
      t.references :common_benefit_item, null: false
      t.integer :olympic_diplom_type_id

      t.timestamps
    end
  end
end
