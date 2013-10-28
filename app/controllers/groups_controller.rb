class GroupsController < ApplicationController
  load_resource

  def index
    authorize! :index, :groups
  end

  def print_group
    authorize! :index, :groups
    @group = Group.find(params[:group_id])
    respond_to do |format|
      format.pdf {
        response.headers['Content-Disposition'] = 'attachment; filename="' + "Список студентов группы #{@group.name}.pdf" + '"'
      }
    end
  end

end