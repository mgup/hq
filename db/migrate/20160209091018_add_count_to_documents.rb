class AddCountToDocuments < ActiveRecord::Migration
  def change
    add_column :document, :count, :integer, default: 1
  end
end
