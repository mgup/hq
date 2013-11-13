class CreateActivityCreditType < ActiveRecord::Migration
  def change
    create_table :activity_credit_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
