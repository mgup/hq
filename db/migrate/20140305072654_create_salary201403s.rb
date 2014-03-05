class CreateSalary201403s < ActiveRecord::Migration
  def change
    create_table :salary201403 do |t|
      t.integer :faculty_id
      t.integer :department_id
      t.integer :user_id
      t.decimal :wage_rate, precision: 2
      t.boolean :untouchable, default: false
      t.boolean :has_report
      t.decimal :credits
      t.decimal :previous_premium
      t.decimal :new_premium

      t.timestamps
    end
  end
end
