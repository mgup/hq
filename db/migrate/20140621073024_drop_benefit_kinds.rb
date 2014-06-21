class DropBenefitKinds < ActiveRecord::Migration
  def change
    drop_table :benefit_kinds
  end
end
