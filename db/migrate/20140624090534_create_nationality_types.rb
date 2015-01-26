class CreateNationalityTypes < ActiveRecord::Migration
  def change
    create_table :nationality_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
