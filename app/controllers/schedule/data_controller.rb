class Schedule::DataController < ApplicationController
  def departments
    @departments = Mgup::Schedule.departments
  end

  def rooms
    @rooms = Mgup::Schedule.rooms
  end
end