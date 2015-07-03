class AddDistanceToEntranceExamResults < ActiveRecord::Migration
  def change
    add_column :entrance_exam_results, :distance, :boolean, default: false
  end
end
