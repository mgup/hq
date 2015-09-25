class Notification < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id

  default_scope do
    where(visible: true)
  end
end
