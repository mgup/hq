class Study::ProgressController < ApplicationController

  before_filter :find_group
  
  def index
    @discipline_students = []
    marks = []
    @group.students.each do |student|
      ball = 0
      @disciplines.each do |d|
        d.checkpoints.each do |c|
          ball += c.checkpointmarks.where(student: student).first.mark if  c.checkpointmarks.where(student: student).first != nil
        end
      end
      marks << ball
      @discipline_students << {ball: ball, student: student}
    end
      @max = marks.max
    @discipline_students.each do |ds|
      ds[:progress] = (ds[:ball]*100)/@max
    end
  end

  def discipline
    @discipline =  Study::Discipline.find(params[:id])
    @discipline_students = []
    marks = []
    @group.students.each do |student|
      ball = 0
      @discipline.checkpoints.each do |c|
        ball += c.checkpointmarks.where(student: student).first.mark if  c.checkpointmarks.where(student: student).first != nil
      end
      marks << ball
      @discipline_students << {ball: ball, student: student}
    end
    @max = marks.max
    @discipline_students.each do |ds|
      ds[:progress] = (ds[:ball]*100)/@max
    end
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
    @disciplines = Study::Discipline.from_group(@group)
  end

end