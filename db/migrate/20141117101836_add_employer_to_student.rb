class AddEmployerToStudent < ActiveRecord::Migration
  def change
    add_column :student, :employer, :text
  end
end
