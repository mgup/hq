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

  def disciplines
    render({ json: Study::Discipline.where(subject_year: 2013).from_name(params[:discipline_name]).inject([]) do |disciplines, discipline|
      teachers = []
      discipline.teachers.each do |teacher|
        teachers << teacher.full_name
      end
      disciplines << { id: discipline.id, name: discipline.name, term: discipline.term,
                       group: discipline.group.name, teachers: teachers.join(', '),
                        }
      disciplines
    end })
  end
end