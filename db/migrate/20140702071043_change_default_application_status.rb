class ChangeDefaultApplicationStatus < ActiveRecord::Migration
  def change
    change_column_default :entrance_applications, :status_id, 4
  end
end
