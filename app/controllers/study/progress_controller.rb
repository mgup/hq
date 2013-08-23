class Study::ProgressController < ApplicationController

  before_filter :find_group
  skip_before_filter :authenticate_user! , :only => [:index]
  def index
    authorize! :index, :progress
    @discipline_students = []
    @group.students.each do |student|
      ball = 0
      @disciplines.each do |d|
        ball+=student.ball(d)
      end
      @discipline_students << {ball: ball.round(2), students: student}
    end
    @discipline_students.each do |ds|
      ds[:progress] = @disciplines.count != 0 ? (ds[:ball]/@disciplines.count) : 0
    end
  end

  def discipline
    authorize! :show, :progress
    @discipline = @disciplines.find(params[:id])
    @discipline_students = []
    @group.students.each do |student|
      ball = student.ball(@discipline)
      @discipline_students << {ball: ball, student: student}
    end
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
    @disciplines = Study::Discipline.now.from_group(@group)
  end

end