class AddTimestampsToDisciplineTeacher < ActiveRecord::Migration
  def change
    change_table :subject_teacher do |t|
      t.timestamps
    end
  end
end
