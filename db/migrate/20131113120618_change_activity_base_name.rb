class ChangeActivityBaseName < ActiveRecord::Migration
  def change
    add_column :activities, :base_name, :string
  end
end
