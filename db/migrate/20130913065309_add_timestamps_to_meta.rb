class AddTimestampsToMeta < ActiveRecord::Migration
  def change
    change_table :document_meta do |t|
      t.timestamps
    end
  end
end
