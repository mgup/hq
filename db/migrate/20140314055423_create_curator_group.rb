class CreateCuratorGroup < ActiveRecord::Migration
  def change
    create_table :curator_group do |t|
      t.date          :start_date
      t.date          :end_date

      t.references :group, index: true
      t.references :user, index: true
    end
  end
end
