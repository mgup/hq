class Department < ActiveRecord::Base
  IPIT   = 3
  IIDIZH = 5
  IKIM   = 6
  IGRIK  = 7

  FITIM  = 2
  FPT    = 3
  FRISO  = 4
  FIDIZH = 5
  FEIM   = 6
  FGI    = 7

  self.table_name = 'department'

  alias_attribute :id,           :department_id
  alias_attribute :name,         :department_name
  alias_attribute :abbreviation, :department_sname
  alias_attribute :parent,       :department_parent
  alias_attribute :role,         :department_role

  # Подчинённые подразделения текущего подразделения.
  has_many :subdepartments, class_name: Department,
           foreign_key: :department_parent

  has_many :specialities, class_name: 'Speciality', foreign_key: :speciality_faculty
  has_many :directions
  has_many :groups, through: :specialities

  # Главное подразделение текущего подразделение.
  belongs_to :main_department, class_name: Department,
             foreign_key: :department_parent

  has_many :positions, foreign_key: :acl_position_department
  has_many :users, through: :positions

  validates :name, presence: true
  validates :abbreviation, presence: true

  default_scope do
    where('department_active = 1').order('department_name ASC')
  end

  scope :only_main, -> { where(department_parent: nil) }

  scope :faculties, -> { where(department_role: 'faculty') }
  scope :academic, -> { where(department_role: 'subdepartment') }

  scope :ordered, -> { order(:department_name) }

  scope :without, -> where {
    cond = all
     if where[:id]!=nil
      cond=cond.where('department_id != ?', where[:id]) 
    else
      cond=all
    end
    cond
  }

  def payment_types(year = nil)
    types = []
    if year
      specialities.includes(:payment_types).each do |s|
        years=[]
        payments = s.payment_types.from_year(year)
        years << {year: year, full_time: payments.from_form(101).last,
                  part_time: payments.from_form(102).last, abcsentia: payments.from_form(103).last,
                  distance: payments.from_form(105).last}  if payments != []
        types << { name: s.name + "\n" + s.code, prices: years}
      end
      types.compact.uniq
    else
      specialities.includes(:payment_types).each do |s|
        years = []
        s.payment_types.collect{ |type| type.year}.uniq.each do |year|
          payments = s.payment_types.from_year(year)
          years << {year: year, full_time: payments.from_form(101).last,
                    part_time: payments.from_form(102).last, abcsentia: payments.from_form(103).last,
                    distance: payments.from_form(105).last}  if payments != []
        end
        types << { name: s.name + "\n" + s.code, prices: years} if years != []
      end

      types.compact.uniq
    end
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.faculty {
        xml.id_   id
        xml.short  abbreviation
        xml.name  name
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end

end