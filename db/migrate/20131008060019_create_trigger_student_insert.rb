# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerStudentInsert < ActiveRecord::Migration
  def up
    # create_trigger("student_before_insert_row_tr", :generated => true, :compatibility => 1).
    #     on("student").
    #     before(:insert) do
    #   <<-SQL_ACTIONS
    #
    #      SET
    #         NEW.last_name_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN student ON NEW.student_fname = dictionary.dictionary_id
    #                               LIMIT 1),
    #         NEW.first_name_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN student ON NEW.student_iname = dictionary.dictionary_id
    #                               LIMIT 1),
    #         NEW.patronym_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN student ON NEW.student_oname = dictionary.dictionary_id
    #                               LIMIT 1);
    #   SQL_ACTIONS
    # end
  end

  def down
    # drop_trigger("student_before_insert_row_tr", "student", :generated => true)
  end
end
