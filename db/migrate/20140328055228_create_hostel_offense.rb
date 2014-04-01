class CreateHostelOffense < ActiveRecord::Migration
  def change
    create_table :hostel_offense do |t|
      t.integer    :kind
      t.text       :description
      t.timestamps
    end
  end
end
