class CreateCommonBenefitItems < ActiveRecord::Migration
  def change
    create_table :common_benefit_items do |t|
      #TODO Структура xml не соответствует
      # t.references :competitive_group, null: false
      t.references :benefit_kind, null: false
      t.boolean :is_for_all_olympics

      t.timestamps
      #TODO связь с olympic_levels (olympic_id (видимо, справочник 11?), level_id (???))
    end
  end
end
