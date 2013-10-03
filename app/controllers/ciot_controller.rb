class CiotController < ApplicationController

  def index
    authorize! :manage, :ciot
    @students = Student.includes([:person, :group]).filter(params).page(params[:page])
  end

end