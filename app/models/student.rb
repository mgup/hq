class Student < ActiveRecord::Base
  self.table_name = 'student_group'

  alias_attribute :id,  :student_group_id

  belongs_to :person, class_name: Person, primary_key: :student_id, foreign_key: :student_group_student
  belongs_to :group, class_name: Group, primary_key: :group_id, foreign_key: :student_group_group

  has_many :checkpoint_marks, foreign_key: :checkpoint_mark_student
  has_many :exams, foreign_key: :exam_student_group
  has_many :exam_students, foreign_key: :exam_student_student
  has_many :marks, foreign_key: :mark_student_group

  default_scope do
    select('student_group.*, student.*')
    .joins(:person)
    .order('last_name_hint, first_name_hint, patronym_hint')
  end

  scope :with_group, -> { joins(:group) }

  scope :filter, -> filters {
    cond = all

    if filters.key?(:name)
      fields = %w(last_name_hint first_name_hint patronym_hint)
      names = filters[:name].split(' ').map { |n| "%#{n}%" }

      cond = cond.where((["CONCAT_WS(' ', #{fields.join(',')}) LIKE ?"] * names.size).join(' AND '), *names)
    end

    if filters.key?(:status)
      cond = cond.where(student_group_status: filters[:status])
    end

    if filters.key?(:course)
      cond = cond.joins(:group).where(group: { group_course: filters[:course] })
    end

    cond
  }
end