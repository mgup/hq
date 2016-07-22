class Entrance::BenefitKind < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  def out_of_competition?
    1 == id
  end

  def special_rights?
    4 == id
  end

  def ege_100?
    3 == id
  end
end
