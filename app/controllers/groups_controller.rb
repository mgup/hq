class GroupsController < ApplicationController
  load_resource

  def index
    authorize! :index, :groups
    @faculties = Department.faculties
  end

  def print_group
    authorize! :index, :groups
    @group = Group.find(params[:group_id])
    respond_to do |format|
      format.pdf
    end
  end

end