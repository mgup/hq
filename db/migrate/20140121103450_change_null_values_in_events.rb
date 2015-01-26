class ChangeNullValuesInEvents < ActiveRecord::Migration
  def change
    change_table :event do |t|
       t.change :name, :string , null: false
       t.change :description, :text, null: false
     end
  end
end
