class Report::StructureController < ApplicationController
  # Отчёт по составу контингента.
  def report
    @directions = get_all_actual_directions

    @students = get_all_students
    # @students = []

    @worksheet_filters = {
      0 => proc { |_| true },
      1 => proc { |student| student.group.fulltime? },
      2 => proc { |student| student.group.semitime? },
      3 => proc { |student| student.group.postal? }
    }

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] =
          %Q(attachment; filename="Контингент на #{Time.now}.xlsx")
      end
    end
  end

  private

  def get_all_actual_directions
    Speciality.joins(groups: :students).
      where('student_group_status IN (?)',
            [Student::STATUS_STUDENT,
             Student::STATUS_COMPLETE,
             Student::STATUS_TRANSFERRED_DEBTOR,
             Student::STATUS_DEBTOR]).
      group(:speciality_id).
      order(:speciality_faculty, :speciality_name, :speciality_code).
      where('speciality_id != 1') # FIXME Убрать после раскидывания аспирантуры.
  end

  def get_all_students
    Student.
      where('student_group_status IN (?)',
            [Student::STATUS_STUDENT,
             Student::STATUS_COMPLETE,
             Student::STATUS_TRANSFERRED_DEBTOR,
             Student::STATUS_DEBTOR])#.
      # with_group.where('group_course = 1'). # FIXME Убрать этот запрос.
      # where('group_speciality != 1')
  end
end