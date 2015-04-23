class GroupsController < ApplicationController
  load_and_authorize_resource

  def index
    @faculties = Department.faculties
    unless current_user.is?(:developer) || can?(:work, :all_faculties)
      user_departments = current_user.departments_ids
      @faculties = @faculties.find_all { |f| user_departments.include?(f.id) }
    end
  end

  def print_group
    authorize! :index, :groups
    @group = Group.find(params[:group_id])

    respond_to do |format|
      format.pdf
    end
  end

  def session_call
    @typecall = case params[:typecall]
                when '1' then 'прохождения вступительных испытаний'
                when '2' then 'промежуточной аттестации'
                when '3' then 'государственной итоговой аттестации'
                when '4' then 'итоговой аттестации'
                when '5' then 'подготовки и защиты выпускной квалификационной работы и/или сдачи итоговых государственных экзаменов'
                when '6' then 'завершения диссертации на соискание ученой степени кандидата наук'
                end
    @from = Date.parse(params[:from])
    @to = Date.parse(params[:to])
    @days = (@to - @from).to_i + 1
    @students = Student.where(student_group_id: params[:students_ids])
    @students.each do |student|
      student.proofs << Proof.create(date: Date.today, from: @from, to: @to, ref_type: 'session_call')
    end

    respond_to do |format|
      format.pdf
    end
  end
end
