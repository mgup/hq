class AddShortNameToBenefitKind < ActiveRecord::Migration
  def change
    change_table :entrance_benefit_kinds do |t|
      t.string :short_name
    end
  end
end
