class AddClassNumberToOlympicTotalDocuments < ActiveRecord::Migration
  def change
    add_column :olympic_total_documents, :class_number, :string
  end
end
