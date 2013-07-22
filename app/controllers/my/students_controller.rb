class My::StudentsController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def show ; end

  def update ; end

  private

  def student_params
    params.require(:student)
  end
end