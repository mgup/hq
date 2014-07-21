module Entrance
  # Отчёт со статистикой платного приёма приёмной кампании.
  class PaidEnrollmentReport < Report
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

    # Алгоритм формирования отчёта.
    def _render
      @renderer.title(self)
      @renderer.text(txt_general_info)
      @renderer.image(graph_received_expected_sums)
      @renderer.text('Распределение поступивших платежей по институтам:')
      @renderer.image(graph_received_sums_by_department)
    end

    # Название отчёта.
    def title
      "#{campaign.name}: статистика платного приёма"
    end

    # Общее количество заключённых договоров о образовании.
    def contracts_count
      @contracts.size
    end

    def graph_received_expected_sums
      g = Graphs::SideBar.new('800x175')
      g.data('', [received_for_first_term_sum, expected_for_first_term_sum])
      g.labels = {
        0 => "Поступило #{number_to_currency(received_for_first_term_sum)}",
        1 => "Ожидаем #{number_to_currency(expected_for_first_term_sum)}"
      }
      g.to_png
    end

    def graph_received_sums_by_department
      g = Graphs::SideBar.new('800x200')

      groups = @contracts.group_by { |c| c.application.department.abbreviation }

      sums = []
      groups.each_with_index do |group, index|
        group_sum = group[1].reduce(0.0) { |a, e| a + e.student.total_payments }
        sums << group_sum

        g.labels[index] = "#{group[0]}, #{number_to_currency(group_sum)}"
      end
      g.data('', sums)

      g.to_png
    end

    def txt_general_info
      txt_total_contracts + ' ' + if payed_contracts_count > 0
                                    txt_received_payments
                                  else
                                    txt_no_payments
                                  end
    end

    private

    def txt_total_contracts
      txt = ["Всего заключено #{contracts_count}"]
      txt << Russian.p(contracts_count, 'договор', 'договора', 'договоров')
      txt << 'об образовании на общую сумму'
      txt << number_to_currency(total_sum).gsub(' ', ' ')

      txt.join(' ')
    end

    def txt_received_payments
      txt = ["Из них по #{payed_contracts_count}"]
      txt << Russian.p(payed_contracts_count,
                       'договору', 'договорам', 'договорам')
      txt << 'уже полностью поступил первый обязательный платёж.'

      txt.join(' ')
    end

    def txt_no_payments
      'Ни по одному договору ещё полностью не поступил ' \
      'первый обязательный платёж.'
    end

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
end