class ChangeEntrantsAllowNulls < ActiveRecord::Migration
  def change
    change_column_null :entrance_entrants, :institution, true
    change_column_null :entrance_entrants, :graduation_year, true
    change_column_null :entrance_entrants, :certificate_number, true
    change_column_null :entrance_entrants, :certificate_date, true
  end
end
