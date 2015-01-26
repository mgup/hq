class Hostel::Host < ActiveRecord::Base
  self.table_name = 'hostel'

  alias_attribute :id,             :hostel_id
  alias_attribute :name,           :hostel_name
  alias_attribute :short_name,   :hostel_short_name
  alias_attribute :address,        :hostel_address

  has_many :flats, class_name: Hostel::Flat, primary_key: :hostel_id,
           foreign_key: :flat_hostel

  scope :for_students, -> {where(hostel_id:  [2,3])}
end
