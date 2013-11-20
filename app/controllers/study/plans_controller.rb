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
end