class SessionsController < ApplicationController

  def index 
     @session=Session.new
  end

  def create
    if @session.save
      redirect_to sessions_path, notice: 'Специальность успешно создана.'
    else
      render action: :index
    end
  end

  
end