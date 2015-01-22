module SelectionHelper
#   def calculate_contract_stats(year=2013)
#     total, received, expected = 0, 0, 0
#     Student.off_budget.entrants.with_contract.each do |student|
#       total    += student.tuition_fee[:total]
#       expected += student.tuition_fee[:by_year][year.to_s] / 2
#       received += student.total_payments
#     end
#
#     { total: total, received: received, expected: expected }
#   end
end