class AddDisciplineTeachersIdField < ActiveRecord::Migration
  def up
#    execute <<-SQL
#SET @curRow := 0;
#UPDATE subject_teacher SET id = (@curRow := @curRow + 1) ORDER BY subject_id, teacher_id;
#
#-- ALTER TABLE subject_teacher DROP FOREIGN KEY subject_teacher_copy_ibfk_1;
#-- ALTER TABLE subject_teacher DROP FOREIGN KEY subject_teacher_copy_ibfk_2;
#ALTER TABLE subject_teacher DROP PRIMARY KEY;
#ALTER TABLE subject_teacher CHANGE id id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;
#    SQL
  end
end
