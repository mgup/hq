class AddFieldsToInterview201704s < ActiveRecord::Migration
  def change
    add_column :interview201704s, :department, :string
    add_column :interview201704s, :employee, :string
  end
end
