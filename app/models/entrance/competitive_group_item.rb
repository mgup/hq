class Entrance::CompetitiveGroupItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  belongs_to :direction
  belongs_to :education_level

  def direction_name
    direction.name
  end

  def form
    (number_budget_o > 0 || number_paid_o > 0 || number_quota_o > 0) ? 11 : ((number_budget_oz > 0 || number_paid_oz > 0 || number_quota_oz > 0) ? 12 : 10)
  end

  def form_name
    (number_budget_o > 0 || number_paid_o > 0 || number_quota_o > 0) ? 'очная' : ((number_budget_oz > 0 || number_paid_oz > 0 || number_quota_oz > 0) ? 'очно-заочная' : 'заочная')
  end

  def payed?
    number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0
  end

  def budget_name
    (number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0) ? 'договор' : 'бюджет'
  end
end