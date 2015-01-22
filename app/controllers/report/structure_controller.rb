class Report::StructureController < ApplicationController
  # Отчёт по составу контингента.
  def report
    @directions = get_all_actual_directions
    @bac = @directions.not_masters
    @mag = @directions.masters
    @ioo = @directions.where(speciality_ioo: 1)
    @second = Speciality.where(speciality_id:
      Student.valid_for_today.second_higher.collect { |s| s.group }.uniq.collect { |g| g.speciality.id })
                    .group(:speciality_id)
                    .order(:speciality_faculty, :speciality_name, :speciality_code)
    @students = get_all_students
    # @students = []

    @worksheet_filters = {
      0 => proc { |student| !student.group.speciality.master? && !student.group.second_higher? },
      1 => proc { |student| student.group.fulltime? && !student.group.speciality.master? && !student.group.second_higher? },
      2 => proc { |student| student.group.semitime? && !student.group.speciality.master? && !student.group.second_higher? },
      3 => proc { |student| student.group.postal? && !student.group.speciality.master? && !student.group.second_higher? },
      4 => proc { |student| student.is_debtor? && !student.group.speciality.master? && !student.group.second_higher? },
      5 => proc { |student| student.group.speciality.master? && !student.group.second_higher? },
      6 => proc { |student| student.group.distance? && !student.group.second_higher? },
      7 => proc { |student| student.group.second_higher? }
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
             Student::STATUS_DEBTOR]).with_group.where('group_speciality != 1')
      #with_group.where('group_course = 1'). # FIXME Убрать этот запрос.

  end
end