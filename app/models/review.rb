class Review < ActiveRecord::Base
  belongs_to :appointment # связь с должностями
  belongs_to :review_u, foreign_key: "university_id"
  belongs_to :review_a, foreign_key: "university_auth_id"

  enum status: {
      runs: 0,
      completed: 1,
      expired: 2
  }
  enum order_type: {
      individual: 0,
      group: 1
  }
  enum evaluation: {
      positive: 0,
      negative: 1
  }
  enum paid: {
      yes: 0,
      no: 1
  }
end