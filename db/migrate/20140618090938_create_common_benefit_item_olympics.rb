class CreateCommonBenefitItemOlympics < ActiveRecord::Migration
  def change
    create_table :common_benefit_item_olympics, id: false do |t|
      t.belongs_to :common_benefit_item
      t.belongs_to :use_olympic
    end
  end
end
