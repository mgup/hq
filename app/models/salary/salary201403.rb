class Salary::Salary201403 < ActiveRecord::Base
  self.table_name = 'salary201403'

  belongs_to :user
end
