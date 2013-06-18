class AjaxController < ApplicationController
	def specialities
    specialities = []
    Speciality.from_faculty(params[:faculty]).each do |speciality|
      specialities << { id: speciality.id, code: speciality.code, name: speciality.name }
    end

    render json: specialities
  end

  def groups
    groups = []

    Group.from_speciality(params[:speciality]).from_course(params[:course]).each do |group|
      groups << { id: group.id, name: group.name }
    end

    Group.from_course(params[:course]).each do |group|
      groups << { id: group.id, name: group.name }
    end

    render json: groups
  end

end