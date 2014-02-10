class AddCommentFieldToAchievements < ActiveRecord::Migration
  def change
    add_column :achievements, :comment, :text
  end
end
