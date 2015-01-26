class CiotController < ApplicationController

  def index
    authorize! :manage, :ciot
    @students = Student.includes([:person, :group]).my_filter(params).page(params[:page])
  end

end