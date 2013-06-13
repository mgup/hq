# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersStudentInsertAndStudentUpdate < ActiveRecord::Migration
  def up
    create_trigger("student_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("student").
        after(:insert) do
      <<-SQL_ACTIONS

      UPDATE student
      INNER JOIN dictionary fname ON student_fname = fname.dictionary_id
      INNER JOIN dictionary iname ON student_iname = iname.dictionary_id
      INNER JOIN dictionary oname ON student_oname = oname.dictionary_id
      SET student.last_name_hint = fname.dictionary_ip,
          student.first_name_hint = iname.dictionary_ip,
          student.patronym_hint = oname.dictionary_ip
      WHERE student.student_id = NEW.student_id;
      SQL_ACTIONS
    end

    create_trigger("student_after_update_row_tr", :generated => true, :compatibility => 1).
        on("student").
        after(:update) do |t|
      t.where("OLD.student_fname != NEW.student_fname OR OLD.student_iname != NEW.student_iname OR OLD.student_oname != NEW.student_oname") do
        <<-SQL_ACTIONS

        UPDATE student
        INNER JOIN dictionary fname ON student_fname = fname.dictionary_id
        INNER JOIN dictionary iname ON student_iname = iname.dictionary_id
        INNER JOIN dictionary oname ON student_oname = oname.dictionary_id
        SET student.last_name_hint = fname.dictionary_ip,
            student.first_name_hint = iname.dictionary_ip,
            student.patronym_hint = oname.dictionary_ip
        WHERE student.student_id = NEW.student_id;
        SQL_ACTIONS
      end
    end
  end

  def down
    drop_trigger("student_after_insert_row_tr", "student", :generated => true)

    drop_trigger("student_after_update_row_tr", "student", :generated => true)

    drop_trigger("student_after_update_row_when_old_student_fname_new_student__tr", "student", :generated => true)
  end
end
