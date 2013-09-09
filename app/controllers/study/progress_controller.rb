class Study::ProgressController < ApplicationController

  before_filter :find_group
  skip_before_filter :authenticate_user! , :only => [:index, :discipline]
  def index
    authorize! :index, :progress
  end

  def change_discipline
    authorize! :show, :progress
    find_group
    @discipline_students = []
    if params[:discipline]
      @discipline = Study::Discipline.find(params[:discipline])
      @group.students.each do |student|
        ball = student.ball(@discipline)
        @discipline_students << {ball: ball, student: student, progress: ball}
      end
    else
      @group.students.each do |student|
        ball = 0
        @disciplines.each do |d|
          ball+=student.ball(d)
        end
        @discipline_students << {ball: ball.round(2), student: student}
      end
      @discipline_students.each do |ds|
        ds[:progress] = @disciplines.count != 0 ? (ds[:ball]/@disciplines.count) : 0
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