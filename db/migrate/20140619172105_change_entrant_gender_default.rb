class ChangeEntrantGenderDefault < ActiveRecord::Migration
  def change
    change_column_default :entrance_entrants, :gender, 1
    change_column_null :entrance_entrants, :gender, false
  end
end
