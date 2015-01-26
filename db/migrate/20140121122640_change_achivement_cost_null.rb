class ChangeAchivementCostNull < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE achievements
      SET cost = 0
      WHERE cost IS NULL;
    SQL

    change_column_null :achievements, :cost, false
  end
end
