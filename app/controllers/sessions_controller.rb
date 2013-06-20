class SessionsController < ApplicationController

  def index 
     @sessions = Session.all
  end

  def new 
    @session=Session.new
  end

  def show
    @session = Session.find(params[:id])
  end

  def create
    if @session.save
      redirect_to sessions_path, notice: 'Специальность успешно создана.'
    else
      render action: :index
    end
  end

  
end