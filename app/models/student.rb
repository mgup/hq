class Student < ActiveRecord::Base
  PAYMENT_BUDGET = 1
  PAYMENT_OFF_BUDGET = 2

  self.table_name = 'student_group'

  alias_attribute :id,              :student_group_id
  alias_attribute :payment,         :student_group_tax
  alias_attribute :admission_year,  :student_group_yearin

  belongs_to :person, class_name: Person, primary_key: :student_id, foreign_key: :student_group_student
  belongs_to :group, class_name: Group, primary_key: :group_id, foreign_key: :student_group_group

  has_many :checkpointmarks, class_name: Study::Checkpointmark, foreign_key: :checkpoint_mark_student
  has_many :exam_students, foreign_key: :exam_student_student
  has_many :exams, :through => :exam_students
  has_many :marks, foreign_key: :mark_student_group

  has_many :document_students, class_name: Document::DocumentStudent, primary_key: :student_group_id, foreign_key: :student_group_id
  has_many :documents, class_name: Document::Doc, :through => :document_students

  has_many :payments, class_name: Finance::Payment, primary_key: :student_group_id, foreign_key: :finance_payment_student_group

  default_scope do
    select('student_group.*, student.*')
    .includes(:person)
    .order('last_name_hint, first_name_hint, patronym_hint')
  end

  scope :with_group, -> { joins(:group) }

  scope :off_budget, -> { where(student_group_tax: PAYMENT_OFF_BUDGET) }
  scope :entrants, -> { where(student_group_status: 100) }

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

=begin
    find_by_sql([%q(
SELECT student.*, student_group.*
FROM (
	SELECT
		`student_group`.`student_group_id`
	FROM `student_group`
	LEFT JOIN (
		SELECT *
		FROM `archive_student_group`
		JOIN `order`
			ON
				`order`.`order_id` = `archive_student_group`.`archive_student_group_order`
				AND order_signing >= :date
		ORDER BY order.order_signing DESC, order.order_id DESC
		LIMIT 1
	) AS `archive`
		ON `archive`.`student_group_id` = `student_group`.`student_group_id`
	WHERE
		`student_group`.`student_group_status` IN (101, 107)
		AND `student_group`.`student_group_group` = :group
	GROUP BY `student_group`.`student_group_id`
	HAVING
		AVG(COALESCE(archive.student_group_group, :group)) = :group
		AND COUNT(DISTINCT `archive`.`student_group_group`) <= 1
	UNION
	SELECT
		`student_group`.`student_group_id`
	FROM `student_group`
	JOIN `archive_student_group`
		ON `archive_student_group`.`student_group_id` = `student_group`.`student_group_id`
	JOIN `order`
		ON `order`.`order_id` = `archive_student_group`.`archive_student_group_order`
	WHERE
		`archive_student_group`.`student_group_status` IN (101, 107)
		AND `archive_student_group`.`student_group_group` = :group
		AND `order`.`order_signing` > :date
) AS `studentss`
JOIN student_group ON studentss.student_group_id = student_group.student_group_id
JOIN student ON student_group.student_group_student = student_id

LEFT JOIN archive_student_group AS a16 ON student_group.student_group_id = a16.student_group_id
LEFT JOIN `order` AS o16 ON o16.order_id = a16.archive_student_group_order AND o16.order_template = 16
WHERE o16.order_signing < :date

GROUP BY student_group_id

ORDER BY last_name_hint ASC, first_name_hint ASC, patronym_hint ASC
    ), { group: group, date: date.strftime('%Y-%m-%d') }])
=end

    ids = self.connection.execute(sanitize_sql([%q(
SELECT GROUP_CONCAT(student) AS student_group_id, `group` AS student_group_group
FROM timeline
WHERE change_date >= :date and `group` = :group
GROUP BY `group`
                               ), { group: group, date: date.strftime('%Y-%m-%d') }]))

    find(ids.to_a[0][0].split(','))
  }

  scope :with_contract, -> {
    joins(:documents).includes(:payments)
    .where({ document: { document_type: Document::Doc::TYPE_CONTRACT }})
    .order('document.document_create_date DESC')
  }

  # Факультет, на котором обучается студент.
  def faculty
    group.speciality.faculty
  end

  # Обучается ли студент на бюджетной основе?
  def budget?
    PAYMENT_BUDGET == payment
  end

  # Обучается ли студент на внебюджетной основе?
  def off_budget?
    !budget?
  end

  # Получение информации о договоре на платное обучение.
  def contract
    documents.where(document_type: Document::Doc::TYPE_CONTRACT).first
  end

  # Заключён ли со студентом контракт на платное обучение?
  def has_contract?
    nil != contract
  end

  # Информация по стоимости обучения студента.
  def tuition_fee
    return 0 if budget?

    student_form = group.is_distance? ? Group::FORM_POSTAL : group.form

    total_sum = 0
    {
        by_year: Finance::PaymentType.where(
            finance_payment_type_year: admission_year,
            finance_payment_type_form: student_form,
            finance_payment_type_speciality: group.speciality.id
        ).first.prices.inject(Hash.new(0)) do |by_year, price|
          by_year[price.year.to_s] += price.sum
          total_sum += price.sum
          by_year
        end,
        total: total_sum
    }
  end

  def total_payments
    payments.inject(0) { |result, payment| result += payment.sum; result }
  end
end