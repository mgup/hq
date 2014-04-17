# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersUserInsertAndUserUpdate < ActiveRecord::Migration
  def up
    # create_trigger("user_before_insert_row_tr", :generated => true, :compatibility => 1).
    #     on("user").
    #     before(:insert) do
    #   <<-SQL_ACTIONS
    #
    #      SET
    #         NEW.last_name_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN user ON NEW.user_fname = dictionary.dictionary_id
    #                               LIMIT 1),
    #         NEW.first_name_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN user ON NEW.user_iname = dictionary.dictionary_id
    #                               LIMIT 1),
    #         NEW.patronym_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN user ON NEW.user_oname = dictionary.dictionary_id
    #                               LIMIT 1);
    #   SQL_ACTIONS
    # end
    #
    # create_trigger("user_before_update_row_tr", :generated => true, :compatibility => 1).
    #     on("user").
    #     before(:update) do |t|
    #   t.where("NEW.user_fname <> OLD.user_fname OR NEW.user_iname <> OLD.user_iname OR\n             NEW.user_oname <> OLD.user_oname") do
    #     <<-SQL_ACTIONS
    #
    #      SET
    #         NEW.last_name_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN user ON NEW.user_fname = dictionary.dictionary_id
    #                               LIMIT 1),
    #         NEW.first_name_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN user ON NEW.user_iname = dictionary.dictionary_id
    #                               LIMIT 1),
    #         NEW.patronym_hint = (SELECT dictionary.dictionary_ip
    #                               FROM dictionary
    #                               JOIN user ON NEW.user_oname = dictionary.dictionary_id
    #                               LIMIT 1);
    #     SQL_ACTIONS
    #   end
    # end
  end

  def down
    # drop_trigger("user_before_insert_row_tr", "user", :generated => true)
    #
    # drop_trigger("user_before_update_row_tr", "user", :generated => true)
    #
    # drop_trigger("user_before_update_row_when_new_user_fname_old_user_fname_or_tr", "user", :generated => true)
  end
end
