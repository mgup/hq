class AddCommissionToExam < ActiveRecord::Migration
  def change
    add_column :exam, :exam_leader, :string
    add_column :exam, :exam_commission, :text
  end
end
