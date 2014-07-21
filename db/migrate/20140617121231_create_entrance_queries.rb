class CreateEntranceQueries < ActiveRecord::Migration
  def change
    create_table :entrance_queries do |t|
      t.text :request
      t.text :response

      t.timestamps
    end
  end
end
