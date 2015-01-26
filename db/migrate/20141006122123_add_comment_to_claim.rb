class AddCommentToClaim < ActiveRecord::Migration
  def change
    add_column :event_date_claim, :comment, :text
  end
end
