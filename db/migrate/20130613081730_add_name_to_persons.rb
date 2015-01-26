class AddNameToPersons < ActiveRecord::Migration
  def change
    add_column :student, :last_name_hint, :string
    add_column :student, :first_name_hint, :string
    add_column :student, :patronym_hint, :string
  end
end
