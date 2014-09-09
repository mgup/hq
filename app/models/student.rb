class Student < ActiveRecord::Base
  include Filterable

  include ActionView::Helpers::NumberHelper

  PAYMENT_BUDGET = 1
  PAYMENT_OFF_BUDGET = 2

  MARK_LECTURE_NOT_ATTEND   = 1001
  MARK_LECTURE_ATTEND       = 1002

  MARK_PRACTICAL_BAD        = 2001
  MARK_PRACTICAL_FAIR       = 2004
  MARK_PRACTICAL_GOOD       = 2002
  MARK_PRACTICAL_PERFECT    = 2003

  STATUS_STUDENT            = 101
  STATUS_COMPLETE           = 106
  STATUS_DEBTOR             = 107
  STATUS_ENTRANT            = 100

  self.table_name = 'student_group'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         authentication_keys: [:id]
  def valid_password?(password)
    if self.password.present?
      if ::Digest::MD5.hexdigest(password) == self.encrypted_password
        # self.password = password
        # self.client_password = nil
        # self.save!
        true
      else
        false
      end
    else
      super
    end
  end
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if id = conditions.delete(:id)
      unscoped.where(conditions).where(['lower(student_group_id) = :id', { id: id.downcase }]).first
    else
      unscoped.where(conditions).first
    end
  end


  alias_attribute :id,              :student_group_id
  alias_attribute :status,          :student_group_status
  alias_attribute :record,          :student_group_record
  alias_attribute :abit,            :student_group_abit
  alias_attribute :abitpoints,      :student_group_abitpoints
  alias_attribute :abit_contract,   :student_group_abit_contract
  alias_attribute :accept_type,     :student_group_a_accept_type
  alias_attribute :school,          :student_group_a_school
  alias_attribute :state_line,      :student_group_a_state_line
  alias_attribute :password,        :encrypted_password
  alias_attribute :payment,         :student_group_tax
  alias_attribute :admission_year,  :student_group_yearin

  belongs_to :person, class_name: Person, primary_key: :student_id, foreign_key: :student_group_student
  belongs_to :group, class_name: Group, primary_key: :group_id, foreign_key: :student_group_group
  belongs_to :entrant, class_name: Entrance::Entrant

  has_many :marks, class_name: Study::Mark, foreign_key: :checkpoint_mark_student
  has_many :exams, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :exam_student_group

  has_many :exam_marks, class_name: 'Study::ExamMark', foreign_key: :mark_student_group, primary_key: :student_group_id
  has_many :final_marks, class_name: 'Study::FinalMark', foreign_key: :mark_final_student, primary_key: :student_group_id

  has_many :document_students, class_name: Document::DocumentStudent, primary_key: :student_group_id, foreign_key: :student_group_id
  has_many :documents, class_name: Document::Doc, :through => :document_students

  has_many :payments, class_name: Finance::Payment, primary_key: :student_group_id, foreign_key: :finance_payment_student_group

  has_many :supports, class_name: My::Support, primary_key: :student_group_id,
           foreign_key: :support_student
  has_many :selections,  class_name: My::Select, primary_key: :student_group_id,
           foreign_key: :optional_select_student
  has_many :choices, class_name: My::Choice, through: :selections

  has_many :students_in_order, class_name: Office::OrderStudent, foreign_key: :order_student_student_group_id
  has_many :orders, class_name: Office::Order, through: :students_in_order

  has_many :visitor_event_dates, as: :visitor
  has_many :dates, through: :visitor_event_dates

  has_one :graduate_student

  has_and_belongs_to_many :study_repeats, class_name: 'Study::Repeat', join_table: 'exam_student', foreign_key: 'exam_student_student_group',
                          association_foreign_key: 'exam_student_exam'

  delegate :education_form, to: :group
  delegate :course,         to: :group
  delegate :speciality,     to: :group
  delegate :deeds, to: :person

  default_scope do
    joins(:person)
    .order('last_name_hint, first_name_hint, patronym_hint')
  end

  # ! В одном месте для таких случаев предложили наглый выход !
  def readonly?
    false
  end

  scope :valid, -> { where(student_group_status: [self::STATUS_STUDENT,
                                                  self::STATUS_DEBTOR]) }

  scope :valid_for_today, -> { where(student_group_status: [self::STATUS_STUDENT, self::STATUS_DEBTOR]) }
  scope :valid_student, -> { where(student_group_status: STATUS_STUDENT)}
  scope :with_group, -> { joins(:group) }

  scope :off_budget, -> { where(student_group_tax: PAYMENT_OFF_BUDGET) }
  scope :entrants, -> { where(student_group_status: 100) }

  scope :second_higher, -> { where(student_group_group: Group.second_higher) }
  scope :full_time_study, -> { where(student_group_form: 101) }

  scope :my_filter, -> filters {
    cond = all

    if filters.key?(:name) && filters[:name] != ''
      names = filters[:name].split(' ').map { |n| "%#{n}%" }
      cond = cond.where(
        ['last_name_hint LIKE ?', 'first_name_hint LIKE ?', 'patronym_hint LIKE ?'][0..(names.size-1)].join(' AND ') + ' OR ' +
        ['first_name_hint LIKE ?', 'last_name_hint LIKE ?', 'patronym_hint LIKE ?'][0..(names.size-1)].join(' AND ') + ' OR ' +
        ['first_name_hint LIKE ?', 'patronym_hint LIKE ?', 'last_name_hint LIKE ?'][0..(names.size-1)].join(' AND '), *names, *names, *names,)

    end

    if filters.key?(:status)
      cond = cond.where(student_group_status: filters[:status])
    end

    if filters.key?(:course)
      cond = cond.where(student_group_group: Group.filter(course: filters[:course]))
    end

    if filters.key?(:group)
      cond = cond.where(student_group_group: filters[:group])
    end

    if filters.key?(:speciality)
      cond = cond.where(student_group_group: Group.filter(speciality: filters[:speciality]))
    end
    if filters.key?(:faculty)
      cond = cond.where(student_group_group: Group.filter(faculty: filters[:faculty]))
    end

    if filters.key?(:form)
      cond = cond.where(student_group_group: Group.filter(form: filters[:form]))
    end

    if filters.key?(:finance)
      cond = cond.where(student_group_tax: filters[:finance])
    end

    cond
  }

  def entrance_order
    orders.where('order_template = 16').last
  end

  scope :in_group_at_date, -> group, date {
    group = group.id if group.is_a?(Group)
# SELECT GROUP_CONCAT(student) AS student_group_id, `group` AS student_group_group
# FROM timeline
# WHERE change_date >= :date and `group` = :group
# GROUP BY `group`
    ids = self.connection.execute(sanitize_sql([%q(
SELECT student_group.*, student.*, `group`.*,
	fword.dictionary_ip AS student_fname_ip,
	iword.dictionary_ip AS student_iname_ip,
	oword.dictionary_ip AS student_oname_ip
FROM (
	SELECT
		`student_group`.`student_group_id`
	FROM `student_group`
	LEFT JOIN (
		SELECT archive_student_group.*
		FROM `archive_student_group`
		JOIN `order`
			ON
				`order`.`order_id` = `archive_student_group`.`archive_student_group_order`
				AND `order_signing` >= :date
		ORDER BY order.order_signing DESC, order.order_id DESC
		LIMIT 1
	) AS `archive`
		ON `archive`.`student_group_id` = `student_group`.`student_group_id`
	WHERE
		`student_group`.`student_group_status` IN (101, 107)
		AND `student_group`.`student_group_group` = :group
	GROUP BY `student_group`.`student_group_id`
	HAVING
		AVG(COALESCE(`archive`.`student_group_group`, :group)) = :group
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
JOIN `group` ON group_id = student_group_group
JOIN dictionary AS fword ON fword.dictionary_id = student.student_fname
JOIN dictionary AS iword ON iword.dictionary_id = student.student_iname
JOIN dictionary AS oword ON oword.dictionary_id = student.student_oname
ORDER BY
	student_fname_ip ASC,
	student_iname_ip ASC,
	student_oname_ip ASC
), { group: group, date: date.strftime('%Y-%m-%d') }]))
    # raise date.strftime('%Y-%m-%d').inspect
    find(ids.to_a.collect{|x| x[0]}.split(',')).each_with_object([]){|x,a| a << x unless x.entrance_order.nil? || x.entrance_order.signing_date > date}
  }

  scope :with_contract, -> {
    joins(:documents).includes(:payments)
    .where({ document: { document_type: Document::Doc::TYPE_CONTRACT }})
    .order('document.document_create_date DESC')
  }

  def speciality
    group.speciality
  end


  def group_at_date(date)
    date = date.strftime('%Y-%m-%d')
    group_id = ActiveRecord::Base.connection.execute(
"SELECT `group`.*, `order`.order_signing as 'date'  FROM `group`
JOIN `archive_student_group` ON `archive_student_group`.student_group_group = `group`.group_id AND `archive_student_group`.student_group_id = #{id}
JOIN `order` ON `order`.order_id = `archive_student_group`.archive_student_group_order
WHERE `order`.order_signing >= '#{date}'
UNION
SELECT `group`.*, '#{Date.today.strftime('%Y-%m-%d')}' as date
FROM `group`
JOIN `student_group` ON `student_group`.student_group_group = `group`.group_id AND `student_group`.student_group_id = #{id}
ORDER BY 'date' DESC
LIMIT 1 ")
    Group.find(group_id.to_a[0][0])
  end

  # Факультет, на котором обучается студент.
  def faculty
    group.speciality.faculty
  end

  # нужно найти все valid? и заменить
  def is_valid?
    STATUS_STUDENT == student_group_status || STATUS_DEBTOR == student_group_status
  end

  def course
    group.course
  end

  def entrance_order
    orders.where('order_template = 16').last
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

    student_form = group.distance? ? Group::FORMS[:postal] : group.form

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

  def sex
    person.male? ? 'он' : 'она'
  end

  def disciplines
    Study::Discipline.now.where(subject_group: group).with_brs
  end

  def checkpoints
    Study::Checkpoint.where(checkpoint_subject: disciplines.collect{ |d| d.id })
  end

  def disciplines_by_term(y,t)
    if y == Study::Discipline::CURRENT_STUDY_YEAR && t == Study::Discipline::CURRENT_STUDY_TERM
      group.disciplines.now.with_brs
    else
      group_at_date(Date.new(t == 1 ? y : y+1, t == 1 ? 10 : 4, 15)).disciplines.by_term(y,t).with_brs
    end
  end

  def checkpoints_by_term(y,t)
    Study::Checkpoint.where(checkpoint_subject: disciplines_by_term(y,t).collect{ |d| d.id })
  end

  #def discipline_marks(discipline)
  #  dmarks = []
  #  marks.by_discipline(discipline).each do |mark|
  #    dmarks << {mark: mark.mark, checkpoint: mark.checkpoint}
  #  end
  #  dmarks.reverse.uniq{|m| m[:checkpoint]}
  #end

  def discipline_marks(discipline = nil)
    if !discipline || discipline.is_active?
        date_group = group
    else
        date_group = group_at_date(Date.new((discipline.semester == 1 ? discipline.year : discipline.year+1), (discipline.semester == 1 ? 9 : 4), 15))
    end

    dmarks = []
    # raise group.group_marks(discipline).inspect
    date_group.group_marks(discipline).each_with_object([]){|mark, a| a << mark if mark[2] == id}.each do |mark|
      dmarks << {mark: mark[3], checkpoint: mark[8]}
    end
    dmarks
  end

  def full_name
    person.full_name
  end

  def last_name
    person.last_name
  end

  def first_name
    person.first_name
  end

  def patronym
    person.patronym
  end


  def ball(discipline = nil, y = nil, t = nil)
    if discipline
      l1, p1, n1 = 0.0, 0.0, 0.0
      return 0.0 if discipline.classes.count == 0
      l = discipline.lectures.count
      p = discipline.seminars.count
      if l == 0
        sum_p = 20.0
        sum_l = 0.0
      elsif p == 0
        sum_p = 0.0
        sum_l = 20.0
      else
        sum_p = 15.0
        sum_l = 5.0
      end
      discipline_marks(discipline).each do |mark|
        result = case mark[:mark]
                   when MARK_LECTURE_ATTEND
                     (sum_l/l)
                   when MARK_PRACTICAL_FAIR
                     (sum_p/(3*p))
                   when MARK_PRACTICAL_GOOD
                     ((sum_p*2)/(3*p))
                   when MARK_PRACTICAL_PERFECT
                     (sum_p/p)
                   else
                     0
                 end
        l1 += result if mark[:checkpoint] == 1
        p1 += result if mark[:checkpoint] == 2
        n1 += mark[:mark] if mark[:checkpoint] == 3
      end
      (l1+p1+n1).round 2
    else
      ball = 0.0
      disciplines_by_term(y, t).each do |d|
        ball+=ball(d)
      end
      ball
    end
  end

  def progress(discipline = nil)
    if discipline
      ball(discipline)
    else
      (disciplines.count != 0 ? (ball(nil)/disciplines.count) : 0)
    end
  end

  def got_all_marks(discipline = nil)
    if discipline
      #group.group_marks(discipline).collect{|m| m[2] == id}.length >= discipline.classes.not_future.length
      discipline.classes.count != 0 && marks.by_discipline(discipline).group(:checkpoint_mark_checkpoint).length >= discipline.classes.each_with_object([]){|checkpoint, a| a << checkpoint unless checkpoint.date.future? }.length
    else
      key = true
      disciplines.each do |d|
        key = (key and got_all_marks(d))
      end
      key
    end
  end

  def result(discipline = nil, y = nil, t = nil)
    if discipline
      current = ball(discipline)
      ball = discipline.current_ball != 0 ? 100*(current/discipline.current_ball) : 0.0
      current_progress = current
    else
      current = ball(nil, y, t)
      current_progress = (disciplines_by_term(y,t).size != 0 ? (current/disciplines_by_term(y,t).size) : 0)
      ball = 0
      disciplines_by_term(y,t).each do |d|
        ball+=100*(current_progress/d.current_ball)/disciplines_by_term(y,t).size if d.current_ball != 0
      end
    end
    if discipline and discipline.final_exam and discipline.final_exam.test?
      case ball.round
        when 0..54
          {ball: current, progress: current_progress, mark: 'не зачтено', short: 'незачёт', color: 'danger', width: ball}
        when 55..Float::INFINITY
          {ball: current, progress: current_progress, mark: 'зачтено', short: 'зачёт', color: 'success', width: ball}
      end
    else
      case ball.round
        when 0..54
          {ball: current, progress: current_progress, mark: 'недопущен', short: 'недопущен', color: 'danger', width: ball}
        when  55..69
          {ball: current, progress: current_progress, mark: 'удовлетворительно', short: 'удовл.', color: 'warning', width: ball}
        when 70..85
          {ball: current, progress: current_progress, mark: 'хорошо', short: 'хорошо', color: 'info', width: ball}
        when 86..Float::INFINITY
          {ball: current, progress: current_progress, mark: 'отлично', short: 'отлично', color: 'success', width: ball}
      end
    end
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.student {
        xml.id_   id
        xml.abitpoints abitpoints
        xml.abit abit
        xml.contract abit_contract
        xml.accept_type accept_type
        xml.state_line state_line
        xml.education_source payment
        xml << person.to_nokogiri.root.to_xml
        xml << group.to_nokogiri.root.to_xml
        xml << speciality.to_nokogiri.root.to_xml
        xml << entrant.to_nokogiri.root.to_xml if entrant
      }
    }.doc
  end

  def study_time
    case group.form
      when 101
        group.speciality.speciality_olength
      when 102
        group.speciality.speciality_ozlength
      else
        group.speciality.speciality_zlength
    end
  end

  def to_xml
    to_nokogiri.to_xml
  end

  def rdr_id
    client = TinyTds::Client.new(username: ENV['LIBRARY_USERNAME'], password: ENV['LIBRARY_PASSWORD'],
                                 dataserver: '192.168.200.36:1433', database: '[marc 1.11]')
    if admission_year < 2012
      query = "SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{full_name}'"
    else
      query = "SELECT RDR_ID FROM dbo.READERS WHERE MATRIX_STUDENT_GROUP_ID = #{id}"
    end
    rdr = client.execute(query).collect{|x| x}
    if rdr.empty?
      return false
    else
      return rdr.last['RDR_ID']
    end
  end

  def exam_progress(year, semester)
    val_2 = []
    val_3 = []
    val_4 = []
    val_5 = []
    final_marks.from_year_and_semester(year, semester).each do |mark|
      val_2 << mark if (mark.value == Study::ExamMark::VALUE_2 || mark.value == Study::ExamMark::VALUE_NEZACHET || mark.value == Study::ExamMark::VALUE_NEDOPUSCHEN)
      val_3 << mark if mark.value == Study::ExamMark::VALUE_3
      val_4 << mark if mark.value == Study::ExamMark::VALUE_4
      val_5 << mark if (mark.value == Study::ExamMark::VALUE_5 || mark.value == Study::ExamMark::VALUE_ZACHET)
    end
    exam_marks.from_year_and_semester(year, semester).each do |mark|
      val_2 << mark if (mark.value == Study::ExamMark::VALUE_2 || mark.value == Study::ExamMark::VALUE_NEZACHET || mark.value == Study::ExamMark::VALUE_NEDOPUSCHEN)
      val_3 << mark if mark.value == Study::ExamMark::VALUE_3
      val_4 << mark if mark.value == Study::ExamMark::VALUE_4
      val_5 << mark if (mark.value == Study::ExamMark::VALUE_5 || mark.value == Study::ExamMark::VALUE_ZACHET)
    end
    if !val_2.empty?
      return 2
    elsif !val_3.empty?
      return 3
    elsif !val_4.empty?
      return 4
    elsif !val_5.empty?
      return 5
    else
      return nil
    end
  end
end
