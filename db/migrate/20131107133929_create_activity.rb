class CreateActivity < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description

      t.references :activity_group, index: true
    end
  end
end
