class CreateEntranceTestBenefitItemOlympics < ActiveRecord::Migration
  def change
    create_table :entrance_test_benefit_item_olympics, id: false do |t|
      t.belongs_to :entrance_test_benefit_item
      t.belongs_to :use_olympic
    end
  end
end
