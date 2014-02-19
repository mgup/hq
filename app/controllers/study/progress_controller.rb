class Study::ProgressController < ApplicationController
  before_filter :find_group
  skip_before_filter :authenticate_user!

  def index
    authorize! :index, :progress
    find_group
    @discipline_students = []
    @students.each do |student|
      @discipline_students << {student: student,
                               progress: student.result()}
    end
  end

  def print_progress
    authorize! :index, :progress
    find_group
    respond_to do |format|
      format.pdf
    end
  end

  def discipline
    authorize! :index, :progress
    find_group
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
    @group = Group.find(params[:group_id])
    @students =  @group.students.valid_for_today.includes([:person, :group])
    @disciplines = Study::Discipline.now.from_group(@group).with_brs
  end

end