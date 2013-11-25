class ChangeActivityPlaceholderType < ActiveRecord::Migration
  def change
    change_column :activities, :placeholder, :text
  end
end
