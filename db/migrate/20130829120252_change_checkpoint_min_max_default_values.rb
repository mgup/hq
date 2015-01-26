class ChangeCheckpointMinMaxDefaultValues < ActiveRecord::Migration
  def change
    change_column :checkpoint, :checkpoint_min, :integer, default: 0
    change_column :checkpoint, :checkpoint_max, :integer, default: 0
  end
end
