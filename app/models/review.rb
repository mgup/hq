class Review < ActiveRecord::Base
  belongs_to :appointment # связь с должностями
  belongs_to :university, foreign_key: :university_id
  belongs_to :university_author, class: University, foreign_key: :university_auth_id

  enum status: {
      runs: 0, # в работе
      completed: 1, # завершена
      expired: 2 # истек срок договора
  }
  enum ordt: {
      indi: 0, # физ лицо
      gr_a: 1 # юр лицо
  }
  enum evaluation: {
      positive: 0, # +
      negative: 1, # -
      undefined: 2 # ?
  }
  enum paid: {
      yes: 0,
      no: 1
  }

end