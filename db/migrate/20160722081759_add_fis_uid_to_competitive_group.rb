class AddFisUidToCompetitiveGroup < ActiveRecord::Migration
  def change
    add_column :competitive_groups, :uid, :integer, default: nil
  end
end
