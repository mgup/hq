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
  has_many :exams, foreign_key: :exam_group
  has_many :subjects, foreign_key: :subject_group
  has_many :disciplines, class_name: Study::Discipline, foreign_key: :subject_group

  default_scope do
    where('group_speciality != 1')
  end

  scope :from_speciality, -> speciality { where(group_speciality: speciality) }
  scope :from_course, -> course { where(group_course: course) }
  scope :from_form, -> form { where(group_form: form) }
  scope :from_faculty, -> faculty {
    joins(:speciality).where(speciality: { speciality_faculty: faculty })
  }

  scope :filter, -> filters {
    [:speciality, :course, :form, :faculty].inject(all) do |cond, field|
      if filters.include?(field) && !filters[field].empty?
        cond = cond.send "from_#{field.to_s}", filters[field]
      end

      cond
    end
  }

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

    case speciality.faculty.id
      when Department::FITIM
        n << 'Ц'
      when Department::FPT
        n << 'Т'
      when Department::FRISO
        n << 'Р'
      when Department::FIDIZH
        n << 'К'
      when Department::FEIM
        n << 'Э'
      when Department::FGI
        n << 'Г'
    end

    n << speciality.suffix

    n << 'Б' if speciality.bachelor?
    n << 'М' if speciality.master?

    n << "-#{course}-#{number}"
    n.join
  end

  def is_distance?
    FORM_DISTANCE == form
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.group {
        xml.id_   id
        xml.name  name
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end