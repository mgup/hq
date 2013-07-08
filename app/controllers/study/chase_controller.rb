class Study::ChaseController < ApplicationController
  
  def index
    if current_user.is?(:typer) 
      redirect_to root_path
    end
    @activity = []
    User.all.each do |user|
      if user.is?(:typer) or user.is?(:supertyper)
        subjects = 0
        marks = 0
        Study::Subject.all.each do |subject|
          subjects += 1 if subject.user_id == user.id
        end
        Study::Mark.all.each do |mark|
          marks += 1 if mark.user_id == user.id
        end
        @activity.push({user: user, subjects: subjects, marks: marks})
      end
    end
  end

end