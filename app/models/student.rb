class Student < ActiveRecord::Base
  self.table_name = 'student_group'

  alias_attribute :id,  :student_group_id

  belongs_to :person, class_name: Person, primary_key: :student_id, foreign_key: :student_group_student
  belongs_to :group, class_name: Group, primary_key: :group_id, foreign_key: :student_group_group

  has_many :checkpointmarks, class_name: Study::Checkpointmark, foreign_key: :checkpoint_mark_student
  has_many :exam_students, foreign_key: :exam_student_student
  has_many :exams, :through => :exam_students
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

    if filters.key?(:group)
      cond = cond.where(student_group_group: filters[:group])
    end

    cond
  }

  scope :in_group_at_date, -> group, date {
    group = group.id if group.is_a?(Group)

    find_by_sql([%q(
      SELECT last_name_hint, first_name_hint, patronym_hint, t.*
      FROM timeline AS t
      JOIN timeline AS t2 ON t.student = t2.student AND t2.change_date >= :date
      JOIN student_group ON student_group_id = t.student
      JOIN student ON student_id = student_group_student
      WHERE t.`group` = :group
      GROUP BY t.student
      HAVING t.change_date = MIN(t2.change_date)
      ORDER BY last_name_hint, first_name_hint, patronym_hint
    ), { group: group, date: date.strftime('%Y-%m-%d') }])

#    ids = self.connection.execute(sanitize_sql([%q(
#SELECT GROUP_CONCAT(student) AS student_group_id, `group` AS student_group_group
#FROM timeline
#WHERE change_date >= :date and `group` = :group
#GROUP BY `group`
#                               ), { group: group, date: date.strftime('%Y-%m-%d') }]))
#
#    find(ids.to_a[0][0].split(','))
  }
end