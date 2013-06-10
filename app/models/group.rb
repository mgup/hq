class Group < ActiveRecord::Base
  self.table_name = 'group'

  alias_attribute :id,     :group_id
  alias_attribute :course, :group_course
  alias_attribute :number, :group_number

  belongs_to :speciality, primary_key: :speciality_id, foreign_key: :group_speciality

  has_many :students, foreign_key: :student_group_group

  def name
    n = []

    n << 'Б' if speciality.bachelor?
    n << 'М' if speciality.master?

    n << "-#{course}-#{number}"
    n.join
  end
end