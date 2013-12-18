class Student < ActiveRecord::Base
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
  STATUS_DEBTOR             = 107

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
  alias_attribute :password,        :encrypted_password
  alias_attribute :payment,         :student_group_tax
  alias_attribute :admission_year,  :student_group_yearin

  belongs_to :person, class_name: Person, primary_key: :student_id, foreign_key: :student_group_student
  belongs_to :group, class_name: Group, primary_key: :group_id, foreign_key: :student_group_group

  has_many :marks, class_name: Study::Mark, foreign_key: :checkpoint_mark_student
  has_many :exams, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :exam_student_group

  has_many :xmarks, class_name: Study::Xmark, foreign_key: :student_id

  has_many :document_students, class_name: Document::DocumentStudent, primary_key: :student_group_id, foreign_key: :student_group_id
  has_many :documents, class_name: Document::Doc, :through => :document_students

  has_many :payments, class_name: Finance::Payment, primary_key: :student_group_id, foreign_key: :finance_payment_student_group

  has_many :supports, class_name: My::Support, primary_key: :student_group_id,
           foreign_key: :support_student
  has_many :selections,  class_name: My::Select, primary_key: :student_group_id,
           foreign_key: :optional_select_student
  has_many :choices, class_name: My::Choice, :through => :selections

  has_many :students_in_order, class_name: Office::OrderStudent, foreign_key: :order_student_student
  has_many :orders, class_name: Office::Order, through: :students_in_order

  has_many :visitor_event_dates, as: :visitor
  has_many :dates, through: :visitor_event_dates


  default_scope do
    joins(:person)
    .order('last_name_hint, first_name_hint, patronym_hint')
  end

  # ! В одном месте для таких случаев предложили наглый выход !
  def readonly?
    false
  end

  scope :valid_for_today, -> { where(student_group_status: [self::STATUS_STUDENT, self::STATUS_DEBTOR]) }

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
      cond = cond.where(student_group_group: Group.from_course(filters[:course]))
    end

    if filters.key?(:group)
      cond = cond.where(student_group_group: filters[:group])
    end

    if filters.key?(:speciality)
      cond = cond.where(student_group_group: Group.includes(:speciality).from_speciality(filters[:speciality]))
    end
    if filters.key?(:faculty)
      cond = cond.where(student_group_group: Group.from_faculty(filters[:faculty]))
    end

    if filters.key?(:form)
      cond = cond.where(student_group_group: Group.from_form(filters[:form]))
    end

    if filters.key?(:finance)
      cond = cond.where(student_group_tax: filters[:finance])
    end

    cond
  }

  scope :in_group_at_date, -> group, date {
    group = group.id if group.is_a?(Group)

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

  def speciality
    group.speciality
  end

  # Факультет, на котором обучается студент.
  def faculty
    group.speciality.faculty
  end

  def valid?
    STATUS_STUDENT == student_group_status || STATUS_DEBTOR == student_group_status
  end

  def course
    group.course
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

  def sex
    person.male? ? 'он' : 'она'
  end

  def subjects
    Study::Subject.where(id: xmarks.collect{|mark| mark.subject_id})
  end

  def disciplines
    Study::Discipline.now.where(subject_group: group).with_brs
  end

  def checkpoints
    Study::Checkpoint.where(checkpoint_subject: disciplines.collect{|d| d.id})
  end

  #def discipline_marks(discipline)
  #  dmarks = []
  #  marks.by_discipline(discipline).each do |mark|
  #    dmarks << {mark: mark.mark, checkpoint: mark.checkpoint}
  #  end
  #  dmarks.reverse.uniq{|m| m[:checkpoint]}
  #end

  def discipline_marks(discipline = nil)
    dmarks = []
    group.group_marks(discipline).each_with_object([]){|mark, a| a << mark if mark[2] == id}.each do |mark|
      dmarks << {mark: mark[3], checkpoint: mark[8]}
    end
    dmarks
  end

  def ball(discipline = nil)
    if discipline
      l1, p1, n1 = 0.0, 0.0, 0.0
      return 0.0 if discipline.classes.count == 0
      l = discipline.lectures.count
      p = discipline.seminars.count
      discipline_marks(discipline).each do |mark|
        result = case mark[:mark]
                   when MARK_LECTURE_ATTEND
                     (5.0/l)
                   when MARK_PRACTICAL_FAIR
                     (5.0/p)
                   when MARK_PRACTICAL_GOOD
                     (10.0/p)
                   when MARK_PRACTICAL_PERFECT
                     (15.0/p)
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
      disciplines.each do |d|
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

  def result(discipline = nil)
    if discipline
      current = ball(discipline)
      ball = discipline.current_ball != 0 ? 100*(current/discipline.current_ball) : 0.0
      current_progress = current
    else
      current = ball()
      current_progress = (disciplines.size != 0 ? (current/disciplines.size) : 0)
      ball = 0
      disciplines.each do |d|
        ball+=100*(current_progress/d.current_ball)/disciplines.size if d.current_ball != 0
      end
    end
    if discipline and discipline.final_exam.test?
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
        xml << person.to_nokogiri.root.to_xml
        xml << group.to_nokogiri.root.to_xml
        xml << speciality.to_nokogiri.root.to_xml
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
end