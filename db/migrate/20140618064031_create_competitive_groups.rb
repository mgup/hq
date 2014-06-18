class CreateCompetitiveGroups < ActiveRecord::Migration
  def change
    create_table :competitive_groups do |t|
      t.belongs_to :campaign
      t.integer :course, null: false, default: 1
      t.string :name, null: false
    end
  end
end
