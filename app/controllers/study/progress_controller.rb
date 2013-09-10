class Study::ProgressController < ApplicationController

  before_filter :find_group
  skip_before_filter :authenticate_user!
  def index
    authorize! :index, :progress
  end

  def change_discipline
    authorize! :index, :progress
    find_group
    @discipline_students = []
    if params[:discipline]
      @discipline = Study::Discipline.find(params[:discipline])
      @group.students.each do |student|
        @discipline_students << {ball: student.ball(@discipline), student: student,
                                          progress: student.progress(@discipline)}
      end
    else
      @discipline = nil
      @group.students.each do |student|
        @discipline_students << {ball: student.ball(@discipline), student: student,
                                          progress: student.progress(@discipline)}
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
    @disciplines = Study::Discipline.now.from_group(@group)
  end

end