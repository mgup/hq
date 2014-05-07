class Group < ActiveRecord::Base
  FORM_FULLTIME = 101
  FORM_SEMITIME = 102
  FORM_POSTAL   = 103
  FORM_DISTANCE = 105

  self.table_name = 'group'

  alias_attribute :id,     :group_id
  alias_attribute :course, :group_course
  alias_attribute :number, :group_number
  alias_attribute :form,   :group_form

  belongs_to :speciality, primary_key: :speciality_id, foreign_key: :group_speciality

  has_many :students, foreign_key: :student_group_group
  has_many :exams, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :exam_group
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
  scope :from_faculty, -> faculty {
    joins(:speciality).where(speciality: { speciality_faculty: faculty })
  }

  scope :second_higher, -> {where(group_second_higher: true)}

  scope :filter, -> filters {
    [:speciality, :course, :form, :faculty].inject(all) do |cond, field|
      if filters.include?(field) && !filters[field].empty?
        cond = cond.send "from_#{field.to_s}", filters[field]
      end

      cond
    end
  }

  scope :without_graduate, -> {
    joins('LEFT JOIN graduates ON graduates.group_id = group.group_id')
    .where('graduates.id IS NULL')
  }

  # Поиск всех групп с выпускниками.
  def self.for_graduate
    Group.all.without_graduate.find_all { |g| g.study_length == g.course }
  end

  def study_length
    case form
      when 101
        speciality.speciality_olength
      when 102
        speciality.speciality_ozlength
      when 103
        speciality.speciality_zlength
      when 105
        speciality.speciality_zlength
    end
  end

  def support
    case form
      when 101
        'очной'
      when 102
        'очно-заочной'
      when 103
        'заочной'
      when 105
        'дистанционной'
    end
  end

  def this_form
    case form
      when 101
        'очная'
      when 102
        'очно-заочная'
      when 103
        'заочная'
      when 105
        'дистанционная'
    end
  end

  def name
    n = []

    case form
      when 101
        n << 'Д'
      when 102
        n << 'В'
      when 103
        n << 'З'
      when 105
        n << 'З'
    end

    #case speciality.faculty.id
    #  when Department::FITIM
    #    n << 'Ц'
    #  when Department::FPT
    #    n << 'Т'
    #  when Department::FRISO
    #    n << 'Р'
    #  when Department::FIDIZH
    #    n << 'К'
    #  when Department::FEIM
    #    n << 'Э'
    #  when Department::FGI
    #    n << 'Г'
    #end
    n << group_name[1]

    n << speciality.suffix

    n << 'Б' if speciality.bachelor?
    n << 'М' if speciality.master?

    n << "-#{course}-#{number}"
    n.join
  end

  def is_distance?
    FORM_DISTANCE == form
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
                                AND (subject_id IN (#{discipline ? discipline.id : disciplines.now.collect{|d| d.id}.join(', ')}))
                                GROUP BY `m1`.`checkpoint_mark_checkpoint`,
  `m1`.`checkpoint_mark_student`,
  `m1`.`checkpoint_mark_submitted` ORDER BY `checkpoint`.`checkpoint_date` ASC, `m1`.`checkpoint_mark_submitted` ASC
  ;")
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.group {
        xml.id_   id
        xml.name  name
        xml.form form
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end