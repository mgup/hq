class GroupsController < ApplicationController
  load_resource

  def index
    authorize! :index, :groups
    @faculties = Department.faculties
    unless current_user.is?(:developer)
      user_departments = current_user.departments_ids
      @faculties = @faculties.find_all { |f| user_departments.include?(f.id) }
    end
  end

  def print_group
    authorize! :index, :groups
    @group = Group.find(params[:group_id])
    respond_to do |format|
      format.pdf
    end
  end

end