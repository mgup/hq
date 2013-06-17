class MarksController < ApplicationController

  def index 
     @mark=Mark.new
     @k=false
  end
  
end