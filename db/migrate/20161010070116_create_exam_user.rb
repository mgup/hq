class CreateExamUser < ActiveRecord::Migration
  def change
    create_table :exam_users do |t|
      t.belongs_to :exam
      t.belongs_to :user
      t.text       :science
      t.boolean    :head
    end
  end
end
