class AddFieldsToDocument < ActiveRecord::Migration
  def change
    add_column :document, :document_department, :longtext
    add_column :document, :document_date, :date
    add_column :document, :document_name, :longtext
    add_column :document, :document_enternal, :boolean, default: false
  end
end
