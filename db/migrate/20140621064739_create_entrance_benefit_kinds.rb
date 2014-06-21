class CreateEntranceBenefitKinds < ActiveRecord::Migration
  def change
    create_table :entrance_benefit_kinds do |t|
      t.string :name

      t.timestamps
    end
  end
end
