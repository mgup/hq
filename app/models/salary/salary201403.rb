class Salary::Salary201403 < ActiveRecord::Base
  TYPE_OK    = 1
  TYPE_LUCKY = 2
  TYPE_KING  = 3

  self.table_name = 'salary201403'

  attr_accessor :final_credit, :final_premium

  belongs_to :user
  belongs_to :department

  #alias_method :old_previous_premium, :previous_premiumgit

  default_scope do
    order(:department_id)
  end

  def untouchable?
    return true if wage_rate.to_f < 1

    return true if new_premium != nil

    return true if subdepartment?

    untouchable
  end

  def touchable?
    !untouchable?
  end

  def type
    return TYPE_KING if subdepartment?

    return TYPE_LUCKY if untouchable?

    return TYPE_OK
  end

  def king?
    TYPE_KING == type
  end

  def lucky?
    TYPE_LUCKY == type
  end
end
