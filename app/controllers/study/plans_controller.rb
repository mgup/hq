class Study::PlansController < ApplicationController
  def index
    authorize! :index, :plans

    @faculties = Department.faculties
    unless current_user.is?(:developer)
      user_departments = current_user.departments_ids
      @faculties = @faculties.find_all { |f| user_departments.include?(f.id) }
    end

    @specialities = Speciality.where(speciality_faculty: @faculties.map { |f| f.id })
    @groups = Group.where(group_speciality: @specialities.map { |s| s.id })

    if current_user.is?(:developer)
      @group = Group.find(params[:group]) if params[:group]
    else
      if params[:group]
        @group = Group.find(params[:group])

        unless user_departments.include?(@group.speciality.faculty.id)
          redirect_to study_plans_path
        end
      end
    end

    @new_discipline = Study::Discipline.new(group: @group, year: params[:year],
                                            semester: params[:term])
    @new_discipline.build_final_exam
  end

  def updatedate
    @exam = Study::Exam.find(params[:exam_id])
    @exam.update date: params[:date]
    respond_to do |format|
      format.js
    end
  end

  def updatediscipline

  end

  def calloz
    @group = Group.find(params[:group])
    @typecall = case params[:typecall]
                when '1' then 'прохождения вступительных испытаний'
                when '2' then 'промежуточной аттестации'
                when '3' then 'государственной итоговой аттестации'
                when '4' then 'итоговой аттестации'
                when '5' then 'подготовки и защиты выпускной квалификационной работы и/или сдачи итоговых государственных экзаменов'
                when '6' then 'завершения диссертации на соискание ученой степени кандидата наук'
                end
    @from = Date.parse params[:from]
    @to = Date.parse params[:to]
    @days = (@to - @from).to_i
    respond_to do |format|
      format.pdf
    end
  end

end