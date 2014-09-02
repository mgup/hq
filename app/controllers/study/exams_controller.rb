class Study::ExamsController < ApplicationController
  before_filter :load_discipline, except: :control
  load_and_authorize_resource :discipline, except: :control
  load_and_authorize_resource through: :discipline, except: [:create, :control]

  def index ; end

  def new ; end

  def edit ; end

  def show
    if @discipline.is_active?
      @students = @discipline.group.students.valid_for_today
    else
      @students = Student.in_group_at_date(@discipline.group, Date.new((@discipline.semester == 1 ? @discipline.year : @discipline.year+1), (@discipline.semester == 1 ? 9 : 4), 15))
    end
  end

  def update
    #raise resource_params.inspect
    @exam.update(resource_params)
    if @exam.save
      redirect_to study_discipline_checkpoints_path(@discipline)
    end
  end

  def updatedate
    @exam.update(resource_params)
    redirect_to study_plans_path(faculty: @exam.discipline.group.speciality.faculty.id,
                                 speciality: @exam.discipline.group.speciality.id,
                                 course: @exam.discipline.group.course,
                                 form: @exam.discipline.group.form,
                                 group: @exam.discipline.group.id)
  end

  def destroy
    @exam.destroy
    redirect_to study_plans_path(faculty: @exam.discipline.group.speciality.faculty.id,
                                 speciality: @exam.discipline.group.speciality.id,
                                 course: @exam.discipline.group.course,
                                 form: @exam.discipline.group.form,
                                 group: @exam.discipline.group.id)
  end

  def create
    exam = params[:study_exam]
    if exam.include?(:exam_group)
      #raise resource_params.inspect
      @exam = Study::Exam.create(resource_params)
    elsif exam.include?(:exam_student_group)
      @exam = Study::Exam.create exam_subject: exam[:exam_subject], parent: exam[:parent], exam_type: exam[:exam_type],
                                 weight: exam[:weight], exam_student: exam[:exam_student], exam_student_group: exam[:exam_student_group],
                                 repeat: exam[:repeat], date: exam[:date]
    end
    redirect_to study_plans_path(faculty: @exam.discipline.group.speciality.faculty.id,
                                 speciality: @exam.discipline.group.speciality.id,
                                 course: @exam.discipline.group.course,
                                 form: @exam.discipline.group.form,
                                 group: @exam.discipline.group.id)
  end

  def control
    @exams_without_form = []
    not_processed = Study::Exam.not_processed
    Department.faculties.each do |faculty|
      groups = []
      originals, mass, individual, originals_c, mass_c, individual_c = 0, 0, 0, 0, 0, 0
      #not_processed = Study::Exam.from_faculty(faculty.id).not_processed
      faculty.groups.each do |group|
        all_exams = group.exams.by_term(params[:year],params[:term])
        exams = not_processed.by_group(group.id).by_term(params[:year],params[:term])
        groups << {group: group, exams: exams} unless exams.empty?
        originals += all_exams.originals.length
        mass += all_exams.mass.length
        individual += all_exams.individual.length
        originals_c += exams.originals.length
        mass_c += exams.mass.length
        individual_c += exams.individual.length
      end
      @exams_without_form << {faculty: faculty, groups: groups, all: {basic: originals, mass: mass, individual: individual},
                                                                control: {basic: originals_c, mass: mass_c, individual: individual_c}}
    end
  end

  def print
    load_discipline
    respond_to do |format|
      format.pdf
    end
  end

  def repeats

  end

  def resource_params
    params.fetch(:study_exam, {}).permit(
      :id, :date, :exam_subject, :parent, :exam_type, :weight, :exam_group, :exam_student,
      :exam_student_group, :repeat, :exam_date,
      final_marks_attributes: [:id, :mark_date, :mark_student_group, :mark_value,
                               :mark_final],
      rating_marks_attributes: [:id, :mark_date, :mark_student_group, :mark_value,
                                :mark_rating, :mark_final],
      students_attributes: [:id, :exam_student_student, :exam_student_student_group,
                            :'_destroy']
    )
  end

  private

  def load_discipline
    @discipline = Study::Discipline.find(params[:discipline_id])
  end
end