class AnalyseController < ApplicationController
  
  def index 
    @collisions = []

    Study::Subject.all.each do |subject|
      Student.in_group_at_date(
          subject.group,
          Time.new((subject.year + 1), (subject.in_fall? ? 1 : 6), 1)).each do |student|
        student_marks = subject.marks.by_student(student)

        marks, retakes = [], []
        student_marks.each do |result|
          marks   << result.mark
          retakes << result.retake
        end

        if marks.uniq.size > 1 || retakes.uniq.size > 1
          errors = []
          errors << 'оценка'    if marks.uniq.size > 1
          errors << 'пересдача' if retakes.uniq.size > 1
        else
          next
        end

        @collisions.push({ subject: subject, student: student,
                           mark: student_marks.first,
                           error_txt: errors.join(' и ') })
      end
    end
  end

end