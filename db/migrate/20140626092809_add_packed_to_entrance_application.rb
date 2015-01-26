class AddPackedToEntranceApplication < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.boolean :packed, comment: 'Сформирован комплект документов'
    end

    execute <<-SQL
UPDATE entrance_applications
SET packed = 1 WHERE original = 1;
    SQL
  end
end
