class CreateEntranceExams < ActiveRecord::Migration
  def change
    create_table :entrance_exams do |t|
      t.belongs_to :campaign
      t.boolean :use
      t.belongs_to :use_subject
      t.string :name

      t.timestamps
    end
  end
end
