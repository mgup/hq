class CreateEntranceUseCheckResult < ActiveRecord::Migration
  def change
    create_table :entrance_use_check_results do |t|
      t.text    :exam_name
      t.integer :score
      t.belongs_to :exam_result
      t.belongs_to :use_check

      t.timestamps
    end
  end
end
