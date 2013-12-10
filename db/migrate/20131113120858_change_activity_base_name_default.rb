class ChangeActivityBaseNameDefault < ActiveRecord::Migration
  def change
    change_column :activities, :base_name, :string, default: 'за одно достижение'
  end
end
