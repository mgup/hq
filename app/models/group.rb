# Модель, представляющая учебную группу.
class Group < ActiveRecord::Base
  include Filterable

  FORMS = { fulltime: 101,
            semitime: 102,
            postal:   103,
            distance: 105 }

  self.table_name = 'group'

  alias_attribute :id,             :group_id
  alias_attribute :course,         :group_course
  alias_attribute :number,         :group_number
  alias_attribute :form,           :group_form
  alias_attribute :education_form, :group_form

  enum group_form: FORMS

  belongs_to :speciality, foreign_key: :group_speciality

  has_many :students, foreign_key: :student_group_group
  has_many :disciplines, class_name: 'Study::Discipline',
                         foreign_key: :subject_group
  has_many :exams, -> { joins(:discipline).where('exam_date IS NOT NULL') },
           class_name: 'Study::Exam',
           through: :disciplines
  has_many :subjects, foreign_key: :subject_group

  # TODO: Изменить на has_and_belongs_to_many.
  has_many :curator_groups, class_name: 'Curator::Group', foreign_key: :group_id
  has_many :curators, through: :curator_groups,
                      class_name: 'User',
                      foreign_key: :user_id

  # FIXME: Я закомментировал эти строчки, потому что из них вообще не понятно,
  # какое они имеют отношение к группе. Определённо, что-то не так.
  # has_one :current_group, lambda {
  #   where("start_date <= '#{Date.today}' AND end_date >= '#{Date.today}'")
  # }, class_name: 'Curator::Group', foreign_key: :group_id

  default_scope do
    includes(speciality: :faculty)
    .order('group_name ASC, group_course ASC, group_number ASC')
  end

  scope :find_all_by_faculty, lambda { |faculty|
    joins(:speciality).where(speciality: { speciality_faculty: faculty })
  }

  scope :with_students, -> {joins(:students).where(student_group: {student_group_status: [Student::STATUS_STUDENT,
                                                                    Student::STATUS_TRANSFERRED_DEBTOR,
                                                                    Student::STATUS_DEBTOR]}).uniq}

  scope :second_higher, -> { where(group_second_higher: true) }
  scope :distance, -> { where(group_form: 105) }

  def study_length
    speciality.send case form
                    when 'fulltime' then :speciality_olength
                    when 'semitime' then :speciality_ozlength
                    when 'postal' then :speciality_zlength
                    when 'distance' then :speciality_zlength
                    else fail 'Неизвестная форма обучения.'
                    end
  end

  def library_form
    case form
      when 'fulltime' then 1
      when 'semitime' then 2
      else 3
    end
  end

  def number_form
    case form
      when 'fulltime' then 101
      when 'semitime' then 102
      when 'postal' then 103
      when 'distance' then 105
    end
  end

  def soccard_form
    case form
    when 'fulltime' then 'DAYTIME'
    when 'semitime' then 'EVENING_TIME'
    when 'postal' then 'DISTANT'
    when 'distance' then 'DISTANT_ONLINE'
    end
  end

  def name
    n = [case form
     when 'fulltime' then 'Д'
     when 'semitime' then 'В'
     when 'postal'   then 'З'
     when 'distance' then 'З'
     else fail 'Неизвестная форма обучения.'
     end,
     group_name[1], speciality.group_name_suffix]
    n << 'Д' if form == 'distance'
    n << 'В' if group_second_higher == 1
    n << "-#{course}-#{number}"
    n.join
  end

  # TODO: Нужно переделать (возможно удалить). Этот вариант мне не нравится.
  def group_marks(d = nil)
    ActiveRecord::Base.connection.execute("
    SELECT
      `m1`.*, `checkpoint`.`checkpoint_type`, `checkpoint`.`checkpoint_min`,
      `checkpoint`.`checkpoint_max`, `checkpoint`.`checkpoint_date`,
      `subject`.`subject_id`
    FROM `checkpoint_mark` AS `m1`
    INNER JOIN `checkpoint` ON checkpoint_id = m1.checkpoint_mark_checkpoint
    INNER JOIN `subject` ON subject_id = checkpoint_subject
    LEFT JOIN `checkpoint_mark` AS `m2`
      ON m1.checkpoint_mark_checkpoint = m2.checkpoint_mark_checkpoint
      AND m1.checkpoint_mark_student = m2.checkpoint_mark_student
      AND m1.checkpoint_mark_submitted < m2.checkpoint_mark_submitted
    WHERE
      (subject_group = #{id}) AND (m2.checkpoint_mark_submitted IS NULL)
      AND (subject_year = #{d.year}) AND (subject_semester = #{d.semester})
      AND (subject_id IN (#{d ? d.id : disciplines.now.map(&:id).join(', ')}))
    GROUP BY
      `m1`.`checkpoint_mark_checkpoint`, `m1`.`checkpoint_mark_student`,
      `m1`.`checkpoint_mark_submitted`
    ORDER BY
      `checkpoint`.`checkpoint_date` ASC, `m1`.`checkpoint_mark_submitted` ASC;"
    )
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.group do
        xml.id_ id
        xml.name name
        xml.form form
      end
    end

    builder.doc.to_xml
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.group do
        xml.id_ id
        xml.name name
        xml.form form
        xml.course course
      end
    }.doc
  end

  def to_nokogiri_empty
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.group do
        xml.id_ id
        xml.name name
      end
    }.doc
  end

  def second_higher?
    group_second_higher == 1
  end
end
