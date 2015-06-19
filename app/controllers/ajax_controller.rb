class AjaxController < ApplicationController
  include Study::MarkHelper
  skip_before_filter :authenticate_user!

  def specialities
    if current_user
      fsp = current_user.is?(:aspirantura) ? Speciality.aspirants : Speciality.all
    else
      fsp = Speciality.all
    end
    render({ json: fsp.from_faculty(params[:faculty]).inject([]) do |specialities, speciality|
      specialities << { id: speciality.id, code: speciality.code, name: speciality.name }
      specialities
    end })
  end

  def flats
    render({ json: Hostel::Flat.from_hostel(params[:hostel]).sort_by{|x| x.number}.inject([]) do |flats, flat|
      flats << { id: flat.id, number: flat.number }
      flats
    end })
  end

  def rooms
    render({ json: Hostel::Room.from_flat(params[:flat]).inject([]) do |rooms, room|
      rooms << { id: room.id, seats: room.description }
      rooms
    end })
  end

  def flat_students
    render({ json: Person.from_flat(params[:flat]).inject([]) do |students, student|
      students << { id: student.id, name: student.full_name }
      students
    end })
  end

  def groups
    filter_groups = Group.with_students
    if params[:speciality] && params[:speciality] != ''
      filter_groups = filter_groups.where(group_speciality: params[:speciality])
    end
    if params[:form] && params[:form] != ''
      filter_groups = filter_groups.where(form: params[:form])
    end
    if params[:course] && params[:course] != ''
      filter_groups = filter_groups.where(course: params[:course])
    end
    render({ json: filter_groups.inject([]) do |groups, group|
      groups << { id: group.id, name: group.name }
      groups
    end })
  end

  def teachers
    render({ json: User.teachers.from_subdepartment(params[:subdepartment]).inject([]) do |teachers, teacher|
      teachers << { id: teacher.id, name: teacher.full_name }
      teachers
    end })
  end

  def disciplines
    render({ json: Study::Discipline.where(subject_year: Study::Discipline::CURRENT_STUDY_YEAR).from_name(params[:discipline_name]).inject([]) do |disciplines, discipline|
      teachers = []
      discipline.teachers.each do |teacher|
        teachers << teacher.full_name
      end
      disciplines << { id: discipline.id, name: discipline.name, term: discipline.term,
                       groups: discipline.group.name, teachers: teachers.join(', '),
                        }
      disciplines
    end })
  end

  def subjects
    render({ json: Study::Subject.from_name(params[:subject_name]).from_group(params[:subject_group]).inject([]) do |subjects, subject|
      subjects << { id: subject.id, title: subject.title, year: subject.year,
                       semester: subject.semester, type: subject.type,
                       group: subject.group.name }
      subjects
    end })
  end

  def students
    render({ json: Student.filter(group: params[:group]).valid_student.inject([]) do |students, student|
      students << { id: student.id, name: student.person.full_name }
      students
    end })
  end

  def group_students
    render({ json: Group.filter(speciality: params[:speciality], form: params[:form], faculty: params[:faculty], course: params[:course]).inject([]) do |groups, group|
      students = []
      group.students.actual.each_with_index do |student, index|
        students << { id: student.id, index: index+1, fullname: student.person.full_name, status: student.status_name }
      end
      groups << { id: group.id, name: group.name, students: students }
      groups
    end })
  end

  def group_exams
    group = Group.find(params[:group])
    disciplines = []
    group.disciplines.now.each do |d|
      exams = []
      d.exams.originals.each do |exam|
        exams << { id: exam.id, name: exam.name, date: ( exam.date ? (l exam.date) : exam.date) }
      end
      disciplines << {id: d.id, name: d.name, exams: exams}
    end
    render({ json: { id: group.id, name: group.name, disciplines: disciplines }})

  end

  def orderstudent
    student = Student.find(params[:id])
    render({ json: {id: student.id, fname: student.person.last_name, iname:  student.person.first_name,
                    oname:  student.person.patronym, faculty: student.group.speciality.faculty.abbreviation,
                    group: student.group.name}
       })
  end

  def ordermeta
    if params[:id] == ''
      meta = Office::OrderMeta.create order_meta_order: params[:order], order_meta_type: params[:type], order_meta_object: params[:object],
                                      order_meta_pattern: params[:pattern], order_meta_text: params[:text]
    else
      meta = Office::OrderMeta.find(params[:id])
      meta.update order_meta_order: params[:order], order_meta_type: params[:type], order_meta_object: params[:object],
                  order_meta_pattern: params[:pattern], order_meta_text: params[:text]
    end
    meta.save!
    render({ json: {id: meta.id} })
  end
  
  def orderreason
    order = Office::Order.find(params[:order])
    order.reasons = Office::Reason.find(params[:reasons])
    render({ json: {text: order.reasons.collect {|reason| reason.pattern}.join(', ')} })
  end

  def checkpoint
    x = Study::Checkpoint.find(params[:checkpoint_id])
    checkpoint = {type: x.checkpoint_type, date: x.date.strftime("%d.%m.%Y"), name: x.name,
                  details: x.details, day: x.date}
    render({ json: checkpoint })
  end

  def count_final
    discipline = Study::Discipline.find(params[:discipline])
    student = Student.find(params[:student])
    current = student.ball(discipline)
    if params[:reason]
      result = mark_count(0, 0, params[:reason])
    else
      final = params[:ball].to_f * discipline.final_exam.weight / 100.0 + (1.0 - discipline.final_exam.weight / 100.0) * current
      result = mark_count(params[:ball], final)
    end
    render({ json: {student: student.id, final: result} })
  end

end