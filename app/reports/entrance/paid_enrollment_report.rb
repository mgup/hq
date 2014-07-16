class Entrance::PaidEnrollmentReport < Report
  attr_reader :generated_at, :campaign, :contracts, :total_sum,
              :expected_for_first_term_sum, :received_for_first_term_sum,
              :payed_contracts_count

  def initialize(campaign = @campaign)
    @generated_at = Time.now

    @campaign = campaign
    @contracts = @campaign.contracts

    @total_sum = 0
    @expected_for_first_term_sum = 0
    @received_for_first_term_sum = 0
    @payed_contracts_count = 0

    detect_sum_and_payments_stats
  end

  # Общее количество заключённых договоров о образовании.
  def contracts_count
    @contracts.size
  end

  private

  def detect_sum_and_payments_stats
    @contracts.each do |contract|
      @total_sum += contract.prices.map(&:price).sum
      expected_for_first_term_sum = contract.one_time_payment
      received_for_first_term_sum = contract.student.total_payments

      if received_for_first_term_sum >= expected_for_first_term_sum
        @payed_contracts_count += 1
      end

      @expected_for_first_term_sum += expected_for_first_term_sum
      @received_for_first_term_sum += received_for_first_term_sum
    end
  end
end