class CreateEducationStatus < ActiveRecord::Migration
  def change
    create_table :education_statuses do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
