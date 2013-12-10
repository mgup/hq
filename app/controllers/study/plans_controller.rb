class Study::PlansController < ApplicationController
  def index

  end

  def add_discipline
    @group = Group.find(params[:group])
    @discipline = Study::Discipline.new
    respond_to do |format|
      format.js
    end
  end

  def edit_discipline
    @group = Group.find(params[:group])
    @discipline = Study::Discipline.find(params[:discipline])
    respond_to do |format|
      format.js
    end
  end

  def repeat
    @group = Group.find(params[:group])
    @parent_exam = Study::Exam.find(params[:exam])
    @exam = Study::Exam.new
    respond_to do |format|
      format.js
    end
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

end