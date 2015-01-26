class AddOurForeignToEduDocument < ActiveRecord::Migration
  def change
    change_table :entrance_edu_documents do |t|
      t.boolean :foreign_institution, null: false, default: false
      t.boolean :our_institution, null: false, default: false
    end
  end
end
