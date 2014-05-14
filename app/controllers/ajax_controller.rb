class AjaxController < ApplicationController
  skip_before_filter :authenticate_user!

  def specialities
    render({ json: Speciality.from_faculty(params[:faculty]).inject([]) do |specialities, speciality|
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
    render({ json: Group.filter(params).inject([]) do |groups, group|
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
    render({ json: Student.filter(group: params[:group]).inject([]) do |students, student|
      students << { id: student.id, name: student.person.full_name }
      students
    end })
  end

  def group_students
    render({ json: Group.filter(params).inject([]) do |groups, group|
      students = []
      group.students.each_with_index do |student, index|
        students << { id: student.id, index: index+1, fullname: student.person.full_name, budget: (student.budget? ? 1 : 0) }
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

  def checkpoint
    x = Study::Checkpoint.find(params[:checkpoint_id])
    checkpoint = {type: x.checkpoint_type, date: x.date.strftime("%d.%m.%Y"), name: x.name,
                  details: x.details, day: x.date}
    render({ json: checkpoint })
  end

  def users
    render({ json: User.filter(params).inject([]) do |users, user|
      users << { id: user.id, name: user.full_name, positions: user.positions.collect{|position| position.title}.push(user.user_position == nil ? [] : user.user_position.split(', ')).flatten.compact.uniq.join(', '),
                username: user.username, phone: (user.phone == nil ? '' : user.phone),
                departments: (user.departments.collect{|department| department.abbreviation} << (Department.find(user.user_department).abbreviation if Department.exists?(user.user_department))).compact.uniq.join(', ')
                                  }
      users
    end })
  end

  def count_final
    discipline = Study::Discipline.find(params[:discipline])
    student = Student.find(params[:student])
    current = student.ball(discipline)
    if params[:reason]
      result = case params[:reason]
                 when '1'
                   {ball: 0, mark: 'неявка', value: Study::ExamMark::VALUE_NEYAVKA, span: 'danger'}
                 when '9'
                   {ball: 0, mark: 'недопущен', value: Study::ExamMark::VALUE_NEDOPUSCHEN, span: 'danger'}
               end
    else
      final = params[:ball].to_f * discipline.final_exam.weight / 100.0 + (1.0 - discipline.final_exam.weight / 100.0) * current
      if params[:ball].to_f < 55
        result = {ball: params[:ball], mark: 'неудовлетворительно', value: Study::ExamMark::VALUE_2, span: 'danger'}
      else
        result = if final >= 85
                   {ball: params[:ball], mark: 'отлично', value: Study::ExamMark::VALUE_5, span: 'success'}
                 elsif final >= 70
                   {ball: params[:ball], mark: 'хорошо', value: Study::ExamMark::VALUE_4, span: 'info'}
                 elsif final >= 55
                   {ball: params[:ball], mark: 'удовлетворительно', value: Study::ExamMark::VALUE_3, span: 'warning'}
                 else
                   {ball: params[:ball], mark: 'неудовлетворительно', value: Study::ExamMark::VALUE_2, span: 'danger'}
                 end
      end

      #if params[:ball].to_f >= 55
      #  result = case final
      #             #when 0..54
      #             #  {ball: final.round, mark: 'неудовлетворительно', value: Study::ExamMark::VALUE_2, span: 'danger'}
      #             when 55..69.999999
      #               {ball: final, mark: 'удовлетворительно', value: Study::ExamMark::VALUE_3, span: 'warning'}
      #             when 70..84.999999
      #               {ball: final, mark: 'хорошо', value: Study::ExamMark::VALUE_4, span: 'info'}
      #             when 85..100
      #               {ball: final, mark: 'отлично', value: Study::ExamMark::VALUE_5, span: 'success'}
      #           end
      #else
      #  result = {ball: final, mark: 'неудовлетворительно', value: Study::ExamMark::VALUE_2, span: 'danger'}
      #end
    end
    render({ json: {student: student.id, final: result} })
  end

end