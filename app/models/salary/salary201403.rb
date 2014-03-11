class Salary::Salary201403 < ActiveRecord::Base
  self.table_name = 'salary201403'

  belongs_to :user
  belongs_to :department

  #alias_method :old_previous_premium, :previous_premiumgit

  default_scope do
    order(:department_id)
  end

  def untouchable?
    return true if wage_rate.to_f < 1


    untouchable
  end
end
