class Study::ProgressController < ApplicationController
  before_filter :find_group
  skip_before_filter :authenticate_user!

  def index
    authorize! :index, :progress
    @discipline_students = []
    @students.each do |student|
      @discipline_students << {student: student,
                               progress: student.result(nil, params[:year].to_i, params[:term].to_i)}
    end
  end

  def print_progress
    authorize! :index, :progress
    respond_to do |format|
      format.pdf
    end
  end

  def discipline
    authorize! :index, :progress
    @discipline_students = []
    @discipline = Study::Discipline.find(params[:discipline])
    @students.each do |student|
      @discipline_students << {student: student,
                                 progress: student.result(@discipline)}
    end
  end


  def change_discipline
    #authorize! :index, :progress
    #find_group
    #@discipline_students = []
    #if params[:discipline]
    #  @discipline = Study::Discipline.find(params[:discipline])
    #  @group.students.includes(:marks).each do |student|
    #    @discipline_students << {ball: student.ball(@discipline), student: student,
    #                                      progress: student.progress(@discipline)}
    #  end
    #else
    #  @group.students.includes(:marks).each do |student|
    #    @discipline_students << {ball: student.ball(), student: student,
    #                                      progress: student.progress()}
    #  end
    #end
    #respond_to do |format|
    #  format.js
    #end
  end

  private

  def find_group
    params[:year] ||= Study::Discipline::CURRENT_STUDY_YEAR
    params[:term] ||= Study::Discipline::CURRENT_STUDY_TERM
    year = params[:year].to_i
    term = params[:term].to_i

    @group = Group.find(params[:group_id])

    if year == Study::Discipline::CURRENT_STUDY_YEAR
      @students =  @group.students.valid_for_today.includes([:person, :group])
    else
      @students =  Student.in_group_at_date(@group, Date.new((term == 1 ? year : year+1), (term == 1 ? 9 : 4), 15))
    end
    @disciplines = Study::Discipline.by_term(year, term).from_group(@group).with_brs
  end

end