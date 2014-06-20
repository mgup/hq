class Entrance::ExamResult < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  enum form: { use: 1, university: 2, payed_test: 3 }

  belongs_to :exam, class_name: Entrance::Exam

  def exam_type
    case form
      when 'use'
        'ЕГЭ'
      when 'university'
        'ВИ'
    end
  end

end
