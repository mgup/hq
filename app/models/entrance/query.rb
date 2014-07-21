class Entrance::Query < ActiveRecord::Base
  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'
end
