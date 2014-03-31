class RenameRatingTable < ActiveRecord::Migration
  def change
    rename_table :rating, :ratings
  end
end
