class Group < ActiveRecord::Base
  FORM_FULLTIME = 101
  FORM_SEMITIME = 102
  FORM_POSTAL   = 103
  FORM_DISTANCE = 105

  self.table_name = 'group'

  alias_attribute :id,             :group_id
  alias_attribute :course,         :group_course
  alias_attribute :number,         :group_number
  alias_attribute :form,           :group_form
  alias_attribute :education_form, :group_form

  enum group_form: { fulltime: FORM_FULLTIME,
                     semitime: FORM_SEMITIME,
                     postal: FORM_POSTAL,
                     distance: FORM_DISTANCE }

  belongs_to :speciality, primary_key: :speciality_id, foreign_key: :group_speciality

  has_many :students, foreign_key: :student_group_group
  #has_many :exams, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :exam_group
  has_many :exams, -> { joins(:discipline).where('exam_date IS NOT NULL') }, class_name: Study::Exam, primary_key: :exam_id, through: :disciplines
  has_many :subjects, foreign_key: :subject_group
  has_many :disciplines, class_name: Study::Discipline, foreign_key: :subject_group

  has_many :curator_groups, class_name: Curator::Group, foreign_key: :group_id
  has_many :curators, through: :curator_groups, class_name: User, foreign_key: :user_id
  has_one :current_group, -> { where("start_date <= '#{Date.today}' AND end_date >= '#{Date.today}'") }, class_name: Curator::Group, foreign_key: :group_id
  #has_one :current_curator, through: :current_curator_group, class_name: User, foreign_key: :user_id

  default_scope do
    includes(speciality: :faculty)
    .order('group_name ASC, group_course ASC, group_number ASC')
  end

  scope :from_speciality, -> speciality { where(group_speciality: speciality) }
  scope :from_course, -> course { where(group_course: course) }
  scope :from_form, -> form { where(group_form: form) }
  scope :from_faculty, -> faculty do
    joins(:speciality).where(speciality: { speciality_faculty: faculty })
  end

  scope :second_higher, -> { where(group_second_higher: true) }

  def self.filter(filters)
    [:speciality, :course, :form, :faculty].inject(all) do |cond, field|
      if filters.include?(field) && !filters[field].empty?
        cond = cond.send "from_#{field.to_s}", filters[field]
      end

      cond
    end
  end

  def self.without_graduate
    joins('LEFT JOIN graduates ON graduates.group_id = group.group_id')
    .where('graduates.id IS NULL')
  end

  # Поиск всех групп с выпускниками.
  def self.for_graduate
    Group.all.without_graduate.find_all { |g| g.study_length == g.course }
  end

  def study_length
    speciality.send case form
                    when 101 then :speciality_olength
                    when 102 then :speciality_ozlength
                    when 103 then :speciality_zlength
                    when 105 then :speciality_zlength
                    else fail 'Неизвестная форма обучения.'
                    end
  end

  def support
    case form
    when 101 then 'очной'
    when 102 then 'очно-заочной'
    when 103 then 'заочной'
    when 105 then 'дистанционной'
    else fail 'Неизвестная форма обучения.'
    end
  end

  def this_form
    case form
    when 101 then 'очная'
    when 102 then 'очно-заочная'
    when 103 then 'заочная'
    when 105 then 'дистанционная'
    else fail 'Неизвестная форма обучения.'
    end
  end

  def library_form
    case form
    when 101 then 1
    when 102 then 2
    else 3
    end
  end

  def name
    n = [] << case form
              when 'fulltime' then 'Д'
              when 'semitime' then 'В'
              when 'postal'   then 'З'
              when 'distance' then 'З'
              else fail 'Неизвестная форма обучения.'
              end

    n << group_name[1]

    n << speciality.suffix

    n << 'Б' if speciality.bachelor?
    n << 'М' if speciality.master?

    n << "-#{course}-#{number}"
    n.join
  end

  def group_marks(discipline = nil)
    ActiveRecord::Base.connection.execute("SELECT `m1`.*, `checkpoint`.`checkpoint_type`, `checkpoint`.`checkpoint_min`, `checkpoint`.`checkpoint_max`, `checkpoint`.`checkpoint_date`, `subject`.`subject_id` FROM `checkpoint_mark` AS `m1`
  INNER JOIN `checkpoint` ON checkpoint_id = m1.checkpoint_mark_checkpoint
  INNER JOIN `subject` ON subject_id = checkpoint_subject
  LEFT JOIN `checkpoint_mark` AS `m2` ON m1.checkpoint_mark_checkpoint = m2.checkpoint_mark_checkpoint
              AND m1.checkpoint_mark_student = m2.checkpoint_mark_student
              AND m1.checkpoint_mark_submitted < m2.checkpoint_mark_submitted
  WHERE (subject_group = #{id}) AND (m2.checkpoint_mark_submitted IS NULL)
                                AND (subject_year = #{discipline ? discipline.year : Study::Discipline::CURRENT_STUDY_YEAR})
                                AND (subject_semester = #{discipline ? discipline.semester : :Study::Discipline::CURRENT_STUDY_TERM})
                                AND (subject_id IN (#{discipline ? discipline.id : disciplines.now.map(&:id).join(', ')}))
                                GROUP BY `m1`.`checkpoint_mark_checkpoint`,
  `m1`.`checkpoint_mark_student`,
  `m1`.`checkpoint_mark_submitted` ORDER BY `checkpoint`.`checkpoint_date` ASC, `m1`.`checkpoint_mark_submitted` ASC
  ;")
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
end
