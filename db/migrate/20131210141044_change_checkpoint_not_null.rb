class ChangeCheckpointNotNull < ActiveRecord::Migration
  def change
    change_column 'checkpoint', 'checkpoint_min', :integer, null: false
    change_column 'checkpoint', 'checkpoint_max', :integer, null: false
  end
end
