class Speciality < ActiveRecord::Base
  self.table_name = 'speciality'

  default_scope { order(:speciality_name, :speciality_code) }

  alias_attribute :id,      :speciality_id
  alias_attribute :code,    :speciality_code
  alias_attribute :name,    :speciality_name
  alias_attribute :type,    :speciality_ntype
  alias_attribute :suffix,  :speciality_short_name

  belongs_to :faculty,
             class_name: 'Department',
             foreign_key: :speciality_faculty

  has_many :groups, foreign_key: :group_speciality
  has_many :payment_types,
           class_name: 'Finance::PaymentType',
           foreign_key: :finance_payment_type_speciality

  scope :from_faculty, -> faculty { where(speciality_faculty: faculty) }
  scope :from_direction, -> direction do
    where(speciality_code: "#{direction.code+'.'+direction.qualification_code.to_s}")
  end
  scope :active, -> { where('speciality_id NOT IN (1,27)')}
  scope :masters, -> { where(speciality_ntype: 2) }
  scope :not_masters, -> {where(speciality_ntype: [0,1])}

  def bachelor?
    1 == type
  end

  def master?
    2 == type
  end

  def specialist?
    0 == type
  end

  def full_name
    code + ' ' + name
  end

  def group_name_suffix
    suffix + case
             when bachelor? then 'Б'
             when master? then 'М'
             else ''
             end
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.speciality do
        xml.id_   id
        xml.code  code
        xml.new_code Direction.where('code = ? AND qualification_code = ?', code.split('.')[0], code.split('.')[1]).first.new_code
        xml.name  name
        xml.type type
        xml << faculty.to_nokogiri.root.to_xml
      end
    end

    builder.doc.to_xml
  end
end
