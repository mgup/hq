class Entrance::ExamResult < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  enum form: { use: 1, university: 2, payed_test: 3 }
end
