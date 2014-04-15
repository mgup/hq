class Study::PlansController < ApplicationController
  def index
    @group = Group.find(params[:group]) if params[:group]
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