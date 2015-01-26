class ChangeNameInUseOlympics < ActiveRecord::Migration
  def change
    change_column :use_olympics, :name, :text
  end
end
