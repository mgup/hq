class AddCompetitveGroupReferenceToCommonBenefitItem < ActiveRecord::Migration
  def change
    change_table :common_benefit_items do |t|
      t.references :competitive_group, null: false
    end
  end
end
