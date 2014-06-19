class AddOlympicYearToEntranceTestBenefitItem < ActiveRecord::Migration
  def change
    add_column :entrance_test_benefit_items, :year, :integer
  end
end
