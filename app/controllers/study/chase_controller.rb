class Study::ChaseController < ApplicationController
  
  def index
    authorize! :index, :typers
    @activity = []
    User.all.each do |user|
      if user.is?(:typer) or user.is?(:supertyper)
        @activity.push({user: user, subjects: user.subjects.all.count,
        marks: user.marks.all.count})
      end
    end
  end

end