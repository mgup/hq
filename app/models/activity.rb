class Activity < ActiveRecord::Base
  validates_presence_of :activity_group_id, :activity_type_id, :name

  belongs_to :activity_group
  belongs_to :activity_type
  belongs_to :activity_credit_type

  has_many :achievements

  def unique?
    unique
  end
end