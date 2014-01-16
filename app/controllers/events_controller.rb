class EventsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    @visitor = VisitorEventDate.new
  end

  def print
    respond_to do |format|
      format.pdf
    end
  end

end