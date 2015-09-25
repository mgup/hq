class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8'do |t|
      t.integer :user_id
      t.string :content
      t.boolean :visible, defautl: :true

      t.timestamps null: false
    end
  end
end
