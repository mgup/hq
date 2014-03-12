class RenameColumnInCuratorTask < ActiveRecord::Migration
  def change
    rename_column :curator_task, :sratus, :status
  end
end
