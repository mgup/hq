class Hostel::Room < ActiveRecord::Base
  self.table_name = 'room'

  alias_attribute :id,             :room_id
  alias_attribute :seats,          :room_seats

  belongs_to :flat, class_name: Hostel::Flat, primary_key: :flat_id,
             foreign_key: :room_flat
  has_many :residents, class_name: Student, primary_key: :room_id,
           foreign_key: :student_room
end