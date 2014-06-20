class Entrance::Application < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  belongs_to :campaign, class_name: 'Entrance::Campaign'
  belongs_to :entrant, class_name: 'Entrance::Entrant'
  belongs_to :competitive_group_item, class_name: 'Entrance::CompetitiveGroupItem'
  belongs_to :competitive_group, :class_name => 'Entrance::CompetitiveGroup'

  scope :paid, -> do
    where('number_paid_o > 0 OR number_paid_oz > 0 OR number_paid_z > 0').
    where('number_budget_o = 0 AND number_budget_oz = 0 AND number_budget_z = 0').
    where('number_quota_o = 0 AND number_quota_oz = 0 AND number_quota_z = 0')
  end

  scope :not_paid, -> do
    where('number_paid_o = 0 AND number_paid_oz = 0 AND number_paid_z = 0')
  end

  scope :o_form, -> do
    where('number_budget_o > 0 OR number_paid_o > 0 OR number_quota_o > 0')
  end

  scope :oz_form, -> do
    where('number_budget_oz > 0 OR number_paid_oz > 0 OR number_quota_oz > 0')
  end

  scope :z_form, -> do
    where('number_budget_z > 0 OR number_paid_z > 0 OR number_quota_z > 0')
  end

  def entrance_type
    use = true
    entrant.exam_results.in_competitive_group(competitive_group_item.competitive_group).each do |exam_result|
      use = false if exam_result.university?
    end

    use ? 'ЕГЭ' : 'Внутренние испытания'
  end
end
