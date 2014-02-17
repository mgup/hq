class GraduateStudentsController < ApplicationController
  load_and_authorize_resource

  def create
    graduate = Graduate.find(params[:graduate_id])

    student = graduate.graduate_students.build
    student.student_id = params[:student_id]

    if student.save
      redirect_to edit_graduate_graduate_student_path(graduate, student), notice: 'Информация о студенте создана.'
    else
      redirect_to students_graduate_path(graduate)
    end
  end

  def edit
    @graduate = @graduate_student.graduate

    # Перед отображением студента необходимо создать для него «заготовки»
    # для внесения информации по оценкам, если таковые ещё не были ни разу сохранены.
    subjects = @graduate.graduate_subjects.only_subjects
    subjects.each do |s|
      @graduate_student.graduate_marks.build(graduate_subject: s) unless s.graduate_marks.where(graduate_student_id: @graduate_student.id).any?
    end

    papers = @graduate.graduate_subjects.only_papers
    papers.each do |p|
      @graduate_student.graduate_marks.build(graduate_subject: p) unless p.graduate_marks.where(graduate_student_id: @graduate_student.id).any?
    end

    works = @graduate.graduate_subjects.only_works
    works.each do |p|
      @graduate_student.graduate_marks.build(graduate_subject: p) unless p.graduate_marks.where(graduate_student_id: @graduate_student.id).any?
    end
  end

  def update
    if @graduate_student.update(resource_params)
      redirect_to students_graduate_path(@graduate_student.graduate), notice: 'Информация о выпуске успешно сохранена.'
    else
      redirect_to students_graduate_path(@graduate_student.graduate), notice: 'Произошла ошибка при сохранении информации о выпуске!'
    end
  end

  def resource_params
    params.fetch(:graduate_student, {}).permit(:thesis, :mark, :registration, :education,
                                               graduate_marks_attributes: [:id, :mark, :graduate_subject_id])
  end
end