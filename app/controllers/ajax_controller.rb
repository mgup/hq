class AjaxController < ApplicationController
	def specialities
    render({ json: Speciality.from_faculty(params[:faculty]).inject([]) do |specialities, speciality|
      specialities << { id: speciality.id, code: speciality.code, name: speciality.name }
      specialities
    end })
  end

  def groups
    render({ json: Group.filter(params).inject([]) do |groups, group|
      groups << { id: group.id, name: group.name }
      groups
    end })
  end
end