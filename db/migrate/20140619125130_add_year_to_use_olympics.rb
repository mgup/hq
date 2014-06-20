class AddYearToUseOlympics < ActiveRecord::Migration
  def change
    add_column :use_olympics, :year, :integer
  end
end
