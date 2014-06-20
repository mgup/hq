class ChangeExamResultTypeToForm < ActiveRecord::Migration
  def change
    rename_column :entrance_exam_results, :type, :form
  end
end
