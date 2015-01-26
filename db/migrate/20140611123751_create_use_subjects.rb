class CreateUseSubjects < ActiveRecord::Migration
  def change
    create_table :use_subjects do |t|
      t.string :name

      t.timestamps
    end
  end
end
