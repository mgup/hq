class AddReportToCuratorTask < ActiveRecord::Migration
  def change
    add_column :curator_task, :report, :text
  end
end
