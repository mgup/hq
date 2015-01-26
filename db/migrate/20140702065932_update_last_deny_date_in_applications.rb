class UpdateLastDenyDateInApplications < ActiveRecord::Migration
  def change
    execute <<-SQL
UPDATE entrance_applications AS a
SET a.last_deny_date = a.updated_at
WHERE a.status_id = 6;
    SQL
  end
end
