class Speciality < ActiveRecord::Base
  self.table_name = 'speciality'

  default_scope { order(:speciality_name, :speciality_code) }

  {
    id: :id,
    code: :code,
    name: :name,
    type: :ntype,
    suffix: :short_name
  }.each do |a, name|
    alias_attribute a, "speciality_#{name}".to_sym
  end

  belongs_to :faculty,
             class_name: 'Department',
             foreign_key: :speciality_faculty

  has_many :groups, foreign_key: :group_speciality
  has_many :payment_types,
           class_name: 'Finance::PaymentType',
           foreign_key: :finance_payment_type_speciality

  # Профили текущего направления.
  has_many :profiles, class_name: Speciality, foreign_key: :speciality_parent

  # Напрвление текущего профиля.
  belongs_to :speciality, class_name: Speciality, foreign_key: :speciality_parent

  belongs_to :direction, class_name: Direction, foreign_key: :direction_id

  scope :from_faculty, -> faculty { where(speciality_faculty: faculty) }
  scope :from_direction, -> direction do
    where("direction_id = '#{direction.id}'")
  end
  scope :active, -> { where('speciality_id NOT IN (1,27)') }
  scope :masters, -> { where(speciality_ntype: 2) }
  scope :not_masters, -> { where(speciality_ntype: [0,1]) }
  scope :not_aspirants, -> { where(speciality_ntype: [0,1,2]) }
  scope :aspirants, -> { where(speciality_ntype: 3) }
  scope :directing, -> { where('speciality_parent IS NULL') }

  def bachelor?
    1 == type
  end

  def master?
    2 == type
  end

  def specialist?
    0 == type
  end

  def aspirant?
    3 == type
  end

  def full_name
    %Q(#{code} «#{name}»)
  end

  def group_name_suffix
    suffix + case
             when bachelor? then 'Б'
             when master? then 'М'
             else ''
             end
  end

  def new_code
    if 2 == code.split('.').size
      Direction.where('code = ? AND qualification_code = ?', code.split('.')[0], code.split('.')[1]).first.new_code
    else
      code
    end
  end

  def calculate_payment_types(year)
    payments = payment_types.from_year(year)
    payments.empty? ? nil : { year: year, full_time: payments.from_form(101).last,
              part_time: payments.from_form(102).last, abcsentia: payments.from_form(103).last,
              distance: payments.from_form(105).last }
  end

  def to_nokogiri
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.speciality do
        [:id, :code, :new_code, :name, :type].each do |field|
          xml.send(field, send(field))
        end
        xml << faculty.to_nokogiri.root.to_xml
      end
    end

    builder.doc
  end

  def name_tvor
    case
    when bachelor? then 'направлению подготовки бакалавриата'
    when master? then 'направлению подготовки магистратуры'
    when aspirant? then 'направлению подготовки аспирантуры'
    else 'специальности'
    end
  end

  delegate :to_xml, to: :to_nokogiri
end
