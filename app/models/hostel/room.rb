class Hostel::Room < ActiveRecord::Base
  self.table_name = 'room'

  alias_attribute :id,             :room_id
  alias_attribute :seats,          :room_seats

  belongs_to :flat, class_name: Hostel::Flat, primary_key: :flat_id,
             foreign_key: :room_flat
  has_many :residents, class_name: Person, primary_key: :room_id,
           foreign_key: :student_room

  scope :from_flat, -> flat {where(room_flat: flat)}

  def description
    "Комната на #{seats} (#{residents.collect{|resident| "#{resident.short_name}, #{resident.students.first.group.name}"}.join('; ')})"
  end
end