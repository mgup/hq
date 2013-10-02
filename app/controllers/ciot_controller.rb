class CiotController < ApplicationController

  def index
    @students = Student.includes([:person, :group]).filter(params).page(params[:page])
  end

end