class Speciality < ActiveRecord::Base
  self.table_name = 'speciality'

  alias_attribute :id,      :speciality_id
  alias_attribute :code,    :speciality_code
  alias_attribute :name,    :speciality_name
  alias_attribute :type,    :speciality_ntype
  alias_attribute :suffix,  :speciality_short_name

  belongs_to :faculty, class_name: Department, primary_key: :department_id, foreign_key: :speciality_faculty

  has_many :groups, foreign_key: :group_speciality
  has_many :payment_types, class_name: Finance::PaymentType, primary_key: :speciality_id, foreign_key: :finance_payment_type_speciality

  default_scope do
    includes(:faculty).order(:speciality_name, :speciality_code)
  end

  scope :from_faculty, -> faculty { where(speciality_faculty: faculty) }
    

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
    full_name = code + " " + name
  end

  def to_nokogiri
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml|
      xml.speciality {
        xml.id_   id
        xml.code  code
        xml.name  name
        xml.type type
        xml << faculty.to_nokogiri.root.to_xml
      }
    }.doc
  end

  def to_xml
    to_nokogiri.to_xml
  end
end