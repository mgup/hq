class AddPhoneToDepartment < ActiveRecord::Migration
  def change
    change_table(:department) do |t|
      t.string :phone, null: true
    end
  end
end
