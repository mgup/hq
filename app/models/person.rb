class Person < ActiveRecord::Base
  MALE = true
  FEMALE = false
  include Nameable

  self.table_name = 'student'

  alias_attribute :id, :student_id
  alias_attribute :birthday, :student_birthday
  alias_attribute :birthplace, :student_birthplace

  alias_attribute :passport_series,     :student_pseries
  alias_attribute :passport_number,     :student_pnumber
  alias_attribute :passport_date,       :student_pdate
  alias_attribute :passport_department, :student_pdepartment
  alias_attribute :passport_department_code, :student_pcode

  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_oname

  def male?
    MALE == student_gender
  end

  def female?
    FEMALE == student_gender
  end

  #trigger.after(:insert) do
  #   %q(
  #     UPDATE student
  #     INNER JOIN dictionary fname ON student_fname = fname.dictionary_id
  #     INNER JOIN dictionary iname ON student_iname = iname.dictionary_id
  #     INNER JOIN dictionary oname ON student_oname = oname.dictionary_id
  #     SET student.last_name_hint = fname.dictionary_ip,
  #         student.first_name_hint = iname.dictionary_ip,
  #         student.patronym_hint = oname.dictionary_ip
  #     WHERE student.student_id = NEW.student_id;
  #   )
  #end

  #trigger.after(:update) do |t|
  #   t.where('OLD.student_fname != NEW.student_fname OR OLD.student_iname != NEW.student_iname OR OLD.student_oname != NEW.student_oname') do
  #     %q(
  #       UPDATE student
  #       INNER JOIN dictionary fname ON student_fname = fname.dictionary_id
  #       INNER JOIN dictionary iname ON student_iname = iname.dictionary_id
  #       INNER JOIN dictionary oname ON student_oname = oname.dictionary_id
  #       SET student.last_name_hint = fname.dictionary_ip,
  #           student.first_name_hint = iname.dictionary_ip,
  #           student.patronym_hint = oname.dictionary_ip
  #       WHERE student.student_id = NEW.student_id;
  #     )
  #   end
  #end
end