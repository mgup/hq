class AddWorkphoneToUser < ActiveRecord::Migration
  change_table(:user) do |t|
    t.string :workphone, null: true
  end
end
