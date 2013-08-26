class AddDefaultToExamClosed < ActiveRecord::Migration
  def change
    change_column :exam, :exam_closed, :integer, default: 0
  end
end
