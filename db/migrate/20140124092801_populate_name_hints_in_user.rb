class PopulateNameHintsInUser < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE user
      INNER JOIN dictionary fname ON user_fname = fname.dictionary_id
      INNER JOIN dictionary iname ON user_iname = iname.dictionary_id
      INNER JOIN dictionary oname ON user_oname = oname.dictionary_id
      SET user.last_name_hint = fname.dictionary_ip,
          user.first_name_hint = iname.dictionary_ip,
          user.patronym_hint = oname.dictionary_ip;
    SQL
  end
end
