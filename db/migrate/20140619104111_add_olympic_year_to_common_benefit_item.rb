class AddOlympicYearToCommonBenefitItem < ActiveRecord::Migration
  def change
    add_column :common_benefit_items, :year, :integer
  end
end
