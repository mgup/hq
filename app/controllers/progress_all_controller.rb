class ProgressAllController < ApplicationController
  
  def index
    if params[:group]
      redirect_to my_path(params[:group])
    end
  end

  def group
    @group = Group.find(params[:id])
  end

end