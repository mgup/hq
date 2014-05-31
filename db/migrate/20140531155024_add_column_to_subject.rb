class AddColumnToSubject < ActiveRecord::Migration
  def change
    add_column 'subject', :department_id, :integer, null: true
  end
end
