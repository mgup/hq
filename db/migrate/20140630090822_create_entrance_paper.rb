class CreateEntrancePaper < ActiveRecord::Migration
  def change
    create_table :entrance_papers do |t|
      t.string  :name
      t.string  :publication
      t.boolean :printed
      t.integer :lists
      t.string  :co_authors

      t.references :entrance_entrant, null: false
    end
  end
end
