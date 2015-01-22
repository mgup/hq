class Hostel::Flat < ActiveRecord::Base
  self.table_name = 'flat'

  alias_attribute :id,             :flat_id
  alias_attribute :entrance,       :flat_entrance
  alias_attribute :floor,          :flat_floor
  alias_attribute :number,         :flat_number
  alias_attribute :type,           :flat_type


  belongs_to :hostel, class_name: Hostel::Host, primary_key: :hostel_id,
           foreign_key: :flat_hostel
  has_many :rooms, class_name: Hostel::Room, primary_key: :flat_id,
           foreign_key: :room_flat
  has_many :residents, class_name: Person, through: :rooms

  scope :from_hostel, -> host {where(flat_hostel:  host)}
end