class Entrance::ExamResult < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  enum form: { use: 1, university: 2, payed_test: 3 }

  belongs_to :exam, class_name: Entrance::Exam
  belongs_to :entrant, class_name: Entrance::Entrant

  scope :in_competitive_group, -> competitive_group do
    joins('LEFT JOIN entrance_test_items ON entrance_test_items.exam_id = entrance_exam_results.exam_id').
    where('entrance_test_items.competitive_group_id = ?', competitive_group.id).
    where('entrance_test_items.id IS NOT NULL')
  end

  scope :by_exam, -> exam_id { where(exam_id: exam_id) }
  scope :from_exam_name, -> exam_name { joins(:exam).where("entrance_exams.name = '#{exam_name}'") }
  scope :vi, -> { where(form: 2) }
  scope :use, -> { where(form: 1) }

  def exam_type
    case form
      when 'use'
        'ЕГЭ'
      when 'university'
        'ВИ'
    end
  end
end
