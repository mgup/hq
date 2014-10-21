module Study
  class ExamsController < ApplicationController
    before_action :load_discipline, except: :control
    load_and_authorize_resource :discipline, except: :control
    load_and_authorize_resource through: :discipline,
                                except: [:create, :control]

    def index ; end

    def new ; end

    def edit ; end

    def show
      @students = if @discipline.is_active?
        @discipline.group.students.valid_for_today
      else
        Student.in_group_at_date(
          @discipline.group,
          Date.new(
            1 == @discipline.semester ? @discipline.year : @discipline.year + 1,
            1 == @discipline.semester ? 9 : 4,
            15
          )
        )
      end
    end

    def update
      @exam.update(resource_params)

      if @exam.save
        respond_to do |format|
          format.js
          format.html do
            redirect_to study_discipline_checkpoints_path(@discipline)
          end
        end
      end
    end

    def updatedate
      @exam.update(resource_params)
      redirect_to path_for_plans(@exam.discipline.group)
    end

    def destroy
      @exam.destroy
      redirect_to path_for_plans(@exam.discipline.group)
    end

    def create
      exam = params[:study_exam]
      @exam = if exam.include?(:exam_group)
        Study::Exam.create(resource_params)
      elsif exam.include?(:exam_student_group)
        Study::Exam.create(
          exam_subject: exam[:exam_subject],
          parent: exam[:parent],
          exam_type: exam[:exam_type],
          weight: exam[:weight],
          exam_student: exam[:exam_student],
          exam_student_group: exam[:exam_student_group],
          repeat: exam[:repeat],
          date: exam[:date])
      end

      redirect_to path_for_plans(@exam.discipline.group)
    end

    def control
      @exams_without_form = []
      not_processed = Study::Exam.not_processed
      Department.faculties.each do |faculty|
        groups = []
        all, control = [Hash.new(0)] * 2
        faculty.groups.each do |group|
          all_exams = group.exams.by_term(params[:year],params[:term])
          exams = not_processed.by_group(group.id).by_term(params[:year], params[:term])
          groups << {group: group, exams: exams} unless exams.empty?
          {
            basic: :originals,
            mass: :mass,
            individual: :individual
          }.each do |key, method|
            all[key] += all_exams.send(method).length
            control[key] += exams.send(method).length
          end
        end
        @exams_without_form << { faculty: faculty,
                                 groups: groups,
                                 all: all,
                                 control: control }
      end
    end

    def print
      load_discipline
      respond_to { |format| format.pdf }
    end

    def repeats ; end

    def resource_params
      params.fetch(:study_exam, {}).permit(
        :id, :date, :exam_subject, :parent, :exam_type, :weight, :exam_group,
        :exam_student, :exam_student_group, :repeat, :exam_date,
        final_marks_attributes: [
          :id, :mark_date, :mark_student_group, :mark_value, :mark_final
        ],
        rating_marks_attributes: [
          :id, :mark_date, :mark_student_group, :mark_value, :mark_rating,
          :mark_final
        ],
        students_attributes: [
          :id, :exam_student_student, :exam_student_student_group, :'_destroy'
        ]
      )
    end

    private

    def load_discipline
      @discipline = Study::Discipline.find(params[:discipline_id])
    end

    def path_for_plans(group)
      study_plans_path(faculty: group.speciality.faculty.id,
                       speciality: group.speciality.id,
                       course: group.course,
                       form: group.form,
                       group: group.id)
    end
  end
end
