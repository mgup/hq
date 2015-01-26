class PopulateNameHintsInPersons < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE student
      INNER JOIN dictionary fname ON student_fname = fname.dictionary_id
      INNER JOIN dictionary iname ON student_iname = iname.dictionary_id
      INNER JOIN dictionary oname ON student_oname = oname.dictionary_id
      SET student.last_name_hint = fname.dictionary_ip,
          student.first_name_hint = iname.dictionary_ip,
          student.patronym_hint = oname.dictionary_ip;
    SQL
  end
end
