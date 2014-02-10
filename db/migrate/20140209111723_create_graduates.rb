class CreateGraduates < ActiveRecord::Migration
  def change
    create_table :graduates do |t|
      t.references :group

      t.integer :year
      t.string :chairman
      t.string :secretary

      t.timestamps
    end
  end
end
