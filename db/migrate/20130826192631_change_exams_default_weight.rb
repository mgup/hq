class ChangeExamsDefaultWeight < ActiveRecord::Migration
  def change
    change_column :exam, :exam_weight, :integer, default: 50
  end
end
