class AddCompetitiveGroupsToEntranceEvent < ActiveRecord::Migration
  def change
    add_column :entrance_events, :competitive_groups, :string
  end
end
