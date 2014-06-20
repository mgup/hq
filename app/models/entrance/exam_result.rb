class Entrance::ExamResult < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  enum form: { use: 1, university: 2, payed_test: 3 }

  belongs_to :exam, class_name: Entrance::Exam

  scope :in_competitive_group, -> competitive_group do
    joins('LEFT JOIN entrance_test_items ON entrance_test_items.exam_id = entrance_exam_results.exam_id').
    where('entrance_test_items.competitive_group_id = ?', competitive_group.id).
    where('entrance_test_items.id IS NOT NULL')
  end

  def exam_type
    case form
      when 'use'
        'ЕГЭ'
      when 'university'
        'ВИ'
    end
  end
end
