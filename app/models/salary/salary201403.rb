class Salary::Salary201403 < ActiveRecord::Base
  self.table_name = 'salary201403'

  belongs_to :user

  #alias_method :old_previous_premium, :previous_premiumgit

  def untouchable?
    return true if wage_rate.to_f < 1

    untouchable
  end
end
