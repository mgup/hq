class Student < ActiveRecord::Base
  include Filterable
  include ActionView::Helpers::NumberHelper
  include Study::CheckpointmarkHelper

  PAYMENT_BUDGET = 1
  PAYMENT_OFF_BUDGET = 2

  MARK_LECTURE_NOT_ATTEND   = 1001
  MARK_LECTURE_ATTEND       = 1002

  MARK_PRACTICAL_BAD        = 2001
  MARK_PRACTICAL_FAIR       = 2004
  MARK_PRACTICAL_GOOD       = 2002
  MARK_PRACTICAL_PERFECT    = 2003

  STATUS_ENTRANT            = 100
  STATUS_STUDENT            = 101
  STATUS_EXPELED            = 102 # отчислен
  STATUS_SABBATICAL         = 103 # академ
  STATUS_GRADUATE           = 104 # выпускник (есть приказ об отчислении по окончании)
  STATUS_POSTGRADUATE       = 105 # аспирант
  STATUS_COMPLETE           = 106 # окончивший (есть приказ об окончании)
  STATUS_DEBTOR             = 107
  STATUS_TRANSFERRED_DEBTOR = 108

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
  # alias_attribute :status,          :student_group_status
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
  belongs_to :status, class_name: EducationStatus, foreign_key: :student_group_status

  has_many :marks, class_name: Study::Mark, foreign_key: :checkpoint_mark_student
  has_many :exams, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :exam_student_group

  has_many :exam_marks, class_name: 'Study::ExamMark', foreign_key: :mark_student_group, primary_key: :student_group_id
  has_many :final_marks, class_name: 'Study::FinalMark', foreign_key: :mark_final_student, primary_key: :student_group_id

  has_many :proofs, foreign_key: :student_group_id, primary_key: :student_group_id

  has_many :document_students, class_name: Document::DocumentStudent, primary_key: :student_group_id, foreign_key: :student_group_id
  has_many :documents, class_name: Document::Doc, :through => :document_students

  has_many :payments, class_name: Finance::Payment, primary_key: :student_group_id, foreign_key: :finance_payment_student_group

  has_many :supports, class_name: My::Support, primary_key: :student_group_id,
           foreign_key: :support_student
  has_many :selections,  class_name: My::Select, primary_key: :student_group_id,
           foreign_key: :optional_select_student
  has_many :choices, class_name: My::Choice, through: :selections

  has_many :students_in_order, class_name: Office::OrderStudent, foreign_key: :order_student_student_group_id
  has_many :archive_students, class_name: 'Archive::Student', foreign_key: :student_group_id
  has_many :orders, class_name: Office::Order, through: :students_in_order

  has_many :visitor_event_dates, as: :visitor
  has_many :dates, through: :visitor_event_dates

  has_and_belongs_to_many :study_repeats, class_name: 'Study::Repeat', join_table: 'exam_student', foreign_key: 'exam_student_student_group',
                          association_foreign_key: 'exam_student_exam'

  delegate :education_form, to: :group
  delegate :course,         to: :group
  delegate :speciality,     to: :group
  delegate :deeds, :last_name, :first_name, :patronym, :full_name, to: :person


  default_scope do
    joins(:person)
    .order('last_name_hint, first_name_hint, patronym_hint')
  end

  scope :transferred_debtors, -> do
    where(student_group_status: self::STATUS_TRANSFERRED_DEBTOR)
  end

  # ! В одном месте для таких случаев предложили наглый выход !
  def readonly?
    false
  end

  scope :valid, -> { where(student_group_status: [self::STATUS_STUDENT,
                                                  self::STATUS_TRANSFERRED_DEBTOR,
                                                  self::STATUS_DEBTOR, self::STATUS_POSTGRADUATE]) }

  scope :valid_for_today, -> { where(student_group_status: [self::STATUS_STUDENT, self::STATUS_TRANSFERRED_DEBTOR, self::STATUS_DEBTOR, self::STATUS_POSTGRADUATE]) }
  scope :valid_student, -> { where(student_group_status: self::STATUS_STUDENT) }

  scope :actual, -> { where("student_group.student_group_status NOT IN (#{self::STATUS_EXPELED},#{self::STATUS_GRADUATE})") }
  scope :soccard, -> { where("student_group.student_group_status IN (#{self::STATUS_ENTRANT},#{self::STATUS_SABBATICAL})") }
  scope :with_group, -> { joins(:group) }

  scope :off_budget, -> { where(student_group_tax: PAYMENT_OFF_BUDGET) }
  scope :entrants, -> { where(student_group_status: 100) }

  scope :second_higher, -> { where(student_group_group: Group.second_higher) }

  scope :full_time_study, -> { joins(:group).where("group.group_form = 101") }

  scope :my_filter, -> filters {   cond = all

  if filters.key?(:name) && filters[:name] != ''
    names = filters[:name].split(' ').map { |n| "%#{n}%" }
    cond = cond.where(
        ['last_name_hint LIKE ?', 'first_name_hint LIKE ?', 'patronym_hint LIKE ?'][0..(names.size-1)].join(' AND ') + ' OR ' +
            ['first_name_hint LIKE ?', 'last_name_hint LIKE ?', 'patronym_hint LIKE ?'][0..(names.size-1)].join(' AND ') + ' OR ' +
            ['first_name_hint LIKE ?', 'patronym_hint LIKE ?', 'last_name_hint LIKE ?'][0..(names.size-1)].join(' AND '), *names, *names, *names,)

  end

  if filters.key?(:status) && filters[:status] != ''
    cond = cond.where(student_group_status: filters[:status])
  end

  if filters.key?(:course) && filters[:course] != ''
    cond = cond.where(student_group_group: Group.filter(course: filters[:course]))
  end

  if filters.key?(:group) && filters[:group] != ''
    cond = cond.where(student_group_group: filters[:group])
  end

  if filters.key?(:speciality) && filters[:speciality] != ''
    cond = cond.where(student_group_group: Group.filter(speciality: filters[:speciality]))
  end
  if filters.key?(:faculty) && filters[:faculty] != ''
    cond = cond.where(student_group_group: Group.filter(faculty: filters[:faculty]))
  end

  if filters.key?(:form) && filters[:form] != ''
    cond = cond.where(student_group_group: Group.filter(form: filters[:form]))
  end

  if filters.key?(:finance) && filters[:finance] != ''
    cond = cond.where(student_group_tax: filters[:finance])
  end

  cond
  }

  scope :from_template, -> template { where(student_group_status: template.statuses.collect{ |s| s.id }) }

  scope :not_aspirants, -> { where(student_group_group: Group.filter(speciality: Speciality.not_aspirants.collect{|x| x.id}))}
  scope :aspirants, -> { where(student_group_group: Group.filter(speciality: Speciality.aspirants.collect{|x| x.id}))}

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
		`student_group`.`student_group_status` IN (101, 108)
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
		`archive_student_group`.`student_group_status` IN (101, 108)
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

    # Проверяем, что в группе есть студенты.
    if ids.any?
      find(ids.to_a.collect{|x| x[0]}.split(',')).each_with_object([]){|x,a| a << x unless ((x.entrance_order.nil?|| x.entrance_order.signing_date > date) && x.admission_year > 2009) }
    else
      none
    end
  }

  scope :with_contract, -> {
    joins(:documents).includes(:payments)
    .where({ document: { document_type: Document::Doc::TYPE_CONTRACT }})
    .order('document.document_create_date DESC')
  }


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
    STATUS_STUDENT == student_group_status || STATUS_DEBTOR == student_group_status || STATUS_TRANSFERRED_DEBTOR == student_group_status || STATUS_POSTGRADUATE == student_group_status
  end

  def is_debtor?
    STATUS_DEBTOR == student_group_status || STATUS_TRANSFERRED_DEBTOR == student_group_status
  end

  def entrance_order
    orders.where('order_template = 16').last
  end

  def expeled_sabbatical_order
    orders.where('order_template IN (14, 15, 42, 26, 24)').last
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

  def pass_discipline?(discipline)
    pass = true
    discipline.checkpoints.each do |checkpoint|
      mark = checkpoint.marks.by_student(self).last
      pass &&= (mark ? mark.mark >= checkpoint.min : false)
    end
    pass
  end

  def discipline_marks(discipline)
    if discipline.is_active?
      date_group = group
    else
      date_group = group_at_date(Date.new((discipline.semester == 1 ? discipline.year : discipline.year+1), (discipline.semester == 1 ? 10 : 4), 15))
    end
    dmarks = []
    date_group.group_marks(discipline).each_with_object([]){ |mark, a| a << mark if mark[2] == id }.each do |mark|
      dmarks << { mark: mark[3], checkpoint: mark[8] }
    end
    dmarks
  end

  def ball(discipline = nil, y = Study::Discipline::CURRENT_STUDY_YEAR, t = Study::Discipline::CURRENT_STUDY_TERM)
    if discipline
      marks = discipline_marks(discipline).collect { |mark|
        if mark[:checkpoint] == 3
          mark[:mark]
        else
          case mark[:mark]
            when MARK_LECTURE_ATTEND
              discipline.lecture_weight
            when MARK_PRACTICAL_FAIR
              discipline.seminar_weight/3
            when MARK_PRACTICAL_GOOD
              discipline.seminar_weight*2/3
            when MARK_PRACTICAL_PERFECT
              discipline.seminar_weight
            else
              0
          end
        end
      }.compact
      marks.empty? ? 0.00 : marks.sum.round(2)
    else
      disciplines_by_term(y,t).collect{|d| ball(d)}.sum
    end
  end

  def progress(discipline = nil)
    if discipline
      r = (discipline.current_ball == 0 ? 0.0 : 100*ball(discipline)/discipline.current_ball)
      r = 100.0 if r > 100
      r
    else
      (disciplines.count != 0 ? (ball(nil)/disciplines.count) : 0)
    end
  end

  def got_all_marks(discipline = nil)
    if discipline
      discipline.classes.count != 0 && marks.by_discipline(discipline).group(:checkpoint_mark_checkpoint).length >= discipline.classes.not_future.length
    else
      disciplines.collect { |d| got_all_marks(d) }.all?
    end
  end

  def result(discipline = nil, y = Study::Discipline::CURRENT_STUDY_YEAR, t = Study::Discipline::CURRENT_STUDY_TERM)
    if discipline
      mark_progress(ball(discipline), progress(discipline), discipline.final_exam.type)
    else
      score = ball(nil, y, t)
      progress = (disciplines_by_term(y,t).size != 0 ? (score/disciplines_by_term(y,t).size) : 0)
      mark_progress(score, progress)
    end
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.student {
        xml.id_  student_group_id
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
                                 dataserver: '192.168.200.211:1444', database: '[Lib19]')
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

  def exam_progress(year_term)
    year = year_term[0]
    semester = year_term[1]
    marks = (exam_marks.from_year_and_semester(year, semester).collect { |m| m.value }).uniq
    case
      when (marks.include?(Study::ExamMark::VALUE_2) || marks.include?(Study::ExamMark::VALUE_NEZACHET) ||
          marks.include?(Study::ExamMark::VALUE_NEDOPUSCHEN) || marks.include?(Study::ExamMark::VALUE_NEYAVKA))
        2
      when marks.include?(Study::ExamMark::VALUE_3)
        3
      when marks.include?(Study::ExamMark::VALUE_4)
        4
      when marks.include?(Study::ExamMark::VALUE_5)
        5
      else
        6
    end

  end

  def self.to_soccard
    doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.file do
        xml.parent.namespace = xml.parent.add_namespace_definition('tns', 'http://university.sm.msr.com/schemas/incoming')
        # xml.parent.namespace = 'tns'
        # xml.parent.namespace = xml.parent.namespace_definitions.find{ |ns| 'tns' == ns.prefix }
        # xml['tns'].child

        xml.fileInfo do
          xml.parent.namespace = nil
          xml.fileSender '028'
          xml.version '1.1.3'
          xml.recordCount self.all.find_all { |s| s.last_status_order && [1,2,3,16,17,25].include?(s.last_status_order.order_template) && s.last_status_order.order_signing >= Date.new(2015, 1, 1) && s.last_status_order.order_signing <= Date.new(2015, 7, 1) }.length
        end
        xml.recordList do
          xml.parent.namespace = nil
          # убрать find_all
          self.all.find_all { |s| s.last_status_order && [1,2,3,16,17,25].include?(s.last_status_order.order_template) && s.last_status_order.order_signing >= Date.new(2015, 1, 1) && s.last_status_order.order_signing <= Date.new(2015, 7, 1) }.each_with_index do |student, index|
            xml.record do
              xml.recordId index+1
              xml.clientInfo do
                xml.name do
                  xml.lastName student.last_name
                  xml.firstName student.first_name
                  xml.middleName student.patronym
                end
                xml.dateOfBirth I18n.l(student.person.birthday, format: '%Y-%m-%d') if student.person.birthday
                xml.sex (student.person.male? ? 1 : 2)
                xml.document do
                  xml.code (student.person.foreign ? 10 : 21)
                  xml.series student.person.passport_series
                  xml.number student.person.passport_number
                  xml.issueDate student.person.passport_date
                  xml.issuedBy student.person.passport_department
                end
                xml.registrationAddress do
                  xml.addressText (student.person.registration_address ? student.person.registration_address : student.person.residence_address)
                end
                xml.residenceAddress do
                  xml.addressText student.person.residence_address
                end
              end
              xml.universityInfo do
                xml.universityCode '028'
                xml.facultyCode student.faculty.soccard_name
                xml.facultyName student.faculty.name
                xml.status do
                  xml.code student.soccard_status
                  xml.date I18n.l(student.last_status_order.order_signing, format: '%Y-%m-%d') if student.last_status_order
                end
                xml.startDate I18n.l(student.start_date_order.order_signing, format: '%Y-%m-%d') if student.start_date_order
                xml.course student.group.course
                xml.educationType student.group.soccard_form
              end
            end
          end
        end
      end
    end

    # fail '123'

    doc.to_xml
  end

  def status_name
    status.name
  end

  def start_date_order
    orr = orders.signed.my_filter(template: [1,2,16,17]).order(:order_signing).last
    unless orr
      # Придумываем студенту дату зачисления.

      orr = orders.build(order_signing: "#{Date.today.year - course}-09-01")
      # fail '123'
    end

    orr
  end

  def last_status_order
    case status.id
      when 103
        orders.signed.my_filter(template: [11,24,26,28]).order(:order_signing).last
      when 102
        orders.signed.my_filter(template: 14).order(:order_signing).last
      when 104
        orders.signed.my_filter(template: 20).order(:order_signing).last
      when 100
        nil
      when 105
        nil
      else
        orr = orders.signed.my_filter(template: [1,2,3,16,17,25]).order(:order_signing).last
        unless orr
          # Придумываем студенту дату зачисления.

          orr = orders.build(order_signing: "#{Date.today.year - course}-09-01")
          # fail '123'
        end

        orr
    end
  end

  def soccard_status
    case status.id
      when 103
        2
      when 102
        3
      when 104
        4
      when 100
        fail
      when 105
        fail
      else
        1
    end
  end

  def valid_for_soccard?
    last_name.present? && first_name.present? && person.birthday.present? && person.passport_number.present? && person.passport_department.present? && person.residence_address.present? &&
        last_status_order && person.passport_date.present?
  end
end
