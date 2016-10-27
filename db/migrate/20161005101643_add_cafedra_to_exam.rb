class AddCafedraToExam < ActiveRecord::Migration
  def change
    add_column :exam, :cafedra, :integer
  end
end
