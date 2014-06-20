class Entrance::CompetitiveGroupItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  belongs_to :direction
  belongs_to :education_level

  def form
    (number_budget_o > 0 || number_paid_o > 0 || number_quota_o > 0) ? 'очная' : ((number_budget_oz > 0 || number_paid_oz > 0 || number_quota_oz > 0) ? 'очно-заочная' : 'заочная')
  end

  def budget
    (number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0) ? 'договор' : 'бюджет'
  end
end