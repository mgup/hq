class ChangeUserAllowNullName < ActiveRecord::Migration
  def change
    change_table :user do |t|
      t.change :user_name, :string, null: true, default: nil
    end
  end
end
