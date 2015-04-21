class CreatePhonebooks < ActiveRecord::Migration
  def change
    create_table :phonebooks do |t|
      t.timestamps
    end
  end
end
