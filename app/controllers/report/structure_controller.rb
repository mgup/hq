class Report::StructureController < ApplicationController
  # Отчёт по составу контингента.
  def report
    @directions = get_all_actual_directions

    @students = get_all_students

    @student_filters = {
      0 => proc { |_| true },
      1 => proc { |student| student.group.fulltime? },
      2 => proc { |student| student.group.semitime? },
      3 => proc { |student| student.group.postal? }
    }

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] =
          %Q(attachment; filename="Контингент на #{Date.today}.xlsx")
      end
    end
  end

  private

  def get_all_actual_directions
    Speciality.select('speciality_id, speciality_code, speciality_name, speciality_ntype').
      joins(groups: :students).
      where('student_group_status IN (?)',
            [Student::STATUS_STUDENT,
             Student::STATUS_COMPLETE,
             Student::STATUS_DEBTOR]).
      group(:speciality_id)
  end

  def get_all_students
    Student.
      where('student_group_status IN (?)',
            [Student::STATUS_STUDENT,
             Student::STATUS_COMPLETE,
             Student::STATUS_DEBTOR])
  end
end