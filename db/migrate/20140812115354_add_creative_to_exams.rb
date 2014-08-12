class AddCreativeToExams < ActiveRecord::Migration
  def change
    change_table :entrance_exams do |t|
      t.boolean :creative, default: false
    end
  end
end
