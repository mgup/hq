class Study::PlansController < ApplicationController
  def index
    user_departments = current_user.departments_ids

    if current_user.is?(:developer)
      @faculties = Department.faculties
      @specialities = Speciality.all
      @groups = Group.all
      @group = Group.find(params[:group]) if params[:group]
    else
      @faculties = Department.faculties.find_all do |f|
        user_departments.include?(f.id)
      end

      @specialities = Speciality.active.find_all do |s|
        user_departments.include?(s.faculty.id)
      end

      @groups = Group.all.find_all do |g|
        user_departments.include?(g.speciality.faculty.id)
      end
      if params[:group]
        @group = Group.find(params[:group])
        unless user_departments.include?(@group.speciality.faculty.id)
          redirect_to study_plans_path
        end
      end
    end


  end

  def updatedate
    @exam = Study::Exam.find(params[:exam_id])
    @exam.update date: params[:date]
    respond_to do |format|
      format.js
    end
  end

  def updatediscipline

  end

end