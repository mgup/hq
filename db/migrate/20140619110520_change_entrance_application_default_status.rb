class ChangeEntranceApplicationDefaultStatus < ActiveRecord::Migration
  def change
    change_column_default :entrance_applications, :status_id, 1
    change_column_null :entrance_applications, :status_id, false
  end
end
