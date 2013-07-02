class AnalyseController < ApplicationController
  
  def index 
    @variants = Array.new
    key = true
     Study::Subject.all.each do |subj|
      case subj.semester
        when 1
          time = Time.new((subj.year + 1), 1, 1)
        when 2
          time = Time.new((subj.year + 1), 6, 1)
      end
      @students = Student.in_group_at_date(subj.group.id, time)
      @students.each do |student|
        variant =  subj.marks.where(student_id: student)
        var = Hash.new
        var['subject'] = subj.id
        var['student'] = student.id
        var['mark'] = variant.first
        marks = Array.new
        retakes = Array.new
        variant.each do |v|
          marks.insert(0, v.mark)
          if v.retake==nil
            retakes.insert(0,0)
          else
            retakes.insert(0,v.retake)
          end
        end 
        var['marks'] = marks.uniq
        var['retakes'] = retakes.uniq
        @variants.insert(-1,var)
      end
    end
  end

end