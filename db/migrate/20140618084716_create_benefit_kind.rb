class CreateBenefitKind < ActiveRecord::Migration
  def change
    create_table :benefit_kinds do |t|
      t.string :name

      t.timestamps
    end
  end
end
