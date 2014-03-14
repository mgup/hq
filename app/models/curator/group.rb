class Curator::Group < ActiveRecord::Base
  self.table_name = 'curator_group'

  belongs_to :curator, class_name: User, foreign_key: :user_id
  belongs_to :group

  def group
    Group.find(group_id)
  end

  scope :active, -> { where("start_date <= '#{Date.today}' AND end_date >= '#{Date.today}'") }

end