class CreateOlympicProfiles < ActiveRecord::Migration
  def change
    create_table :olympic_profiles do |t|
      t.string     :name
    end
  end
end
