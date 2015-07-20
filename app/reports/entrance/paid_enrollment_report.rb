module Entrance
  # Отчёт со статистикой платного приёма приёмной кампании.
  class PaidEnrollmentReport < Report
    attr_reader :generated_at, :campaign_year, :contracts, :total_sum,
                :expected_for_first_term_sum, :received_for_first_term_sum,
                :payed_contracts_count

    def initialize(campaign_year = @campaign_year)
      @generated_at = Time.now

      @campaign_year = campaign_year

      @contracts = []
      Entrance::Campaign.where(start_year: campaign_year).each do |campaign|
        @contracts += campaign.applications.where(is_payed: true).
          find_all { |a| a.contract }.map{ |a| a.contract }
      end

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
      @renderer.text('Необходимо оплатить по заключённым договорам (по институтам):')
      @renderer.image(graph_received_expected_sums_by_department)
      contracts_by_competitive_groups
      contracts_by_direction
    end

    # Название отчёта.
    def title
      "Приём #{campaign_year}: статистика платного приёма"
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

      @grouped_by_department = @contracts.group_by do |contract|
        contract.application.department.abbreviation
      end

      sums = []
      @grouped_by_department.each_with_index do |group, index|
        group_sum = group[1].reduce(0.0) { |a, e| a + e.student.total_payments }
        sums << group_sum

        g.labels[index] = "#{group[0]}, #{number_to_currency(group_sum)}"
      end
      g.data('', sums)

      g.to_png
    end

    def graph_received_expected_sums_by_department
      g = Graphs::SideBar.new('800x200')

      @grouped_by_department = @contracts.group_by do |contract|
        contract.application.department.abbreviation
      end

      sums = []
      @grouped_by_department.each_with_index do |group, index|
        group_sum = group[1].reduce(0.0) do |a, e|
          a + e.one_time_payment - e.student.total_payments
        end

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

    def contracts_by_competitive_groups
      @renderer.text('Распределение договоров по конкурсным группам')

      data = [['Конкурсная группа', 'Очная', 'Очно-заочная', 'Заочная']]
      @grouped_by_department.each do |abbreviation, contracts|
        # next unless 'ИПИТ' == abbreviation

        data << [{content: "[ #{abbreviation} ]", colspan: 4}]

        by_competitive_group = contracts.group_by do |contract|
          # contract.application.competitive_group
          "#{contract.application.competitive_group.items.first.direction.new_code} #{contract.application.competitive_group.name}"
        end

        # by_speciality = contracts.group_by do |contract|
        #   contract.student.group.speciality
        # end

        data_draft = []
        by_competitive_group.each do |competitive_group_title, contracts|
          d = [competitive_group_title, [0, 0], [0, 0], [0, 0]]
          # d = ["#{speciality.new_code} #{speciality.name}", [0, 0], [0, 0], [0, 0]]
          contracts.each do |contract|
            case contract.student.group.form
            when 'fulltime' then d[1][0] += 1
            when 'semitime' then d[2][0] += 1
            when 'postal'   then d[3][0] += 1
            when 'distance' then d[3][0] += 1
            else fail 'Неизвестная форма обучения.'
            end

            if contract.paid?
              case contract.student.group.form
              when 'fulltime' then d[1][1] += 1
              when 'semitime' then d[2][1] += 1
              when 'postal'   then d[3][1] += 1
              when 'distance' then d[3][1] += 1
              else fail 'Неизвестная форма обучения.'
              end
            end
          end

          data_draft << d
        end

        sorted_data = data_draft.sort_by do |row|
          parts = row[0].split('.')
          [parts[2][3..-1], parts[0], parts[1]]
        end

        sorted_data.each do |el|
          data << [el[0], "#{el[1][0]} (#{el[1][1]})", "#{el[2][0]} (#{el[2][1]})", "#{el[3][0]} (#{el[3][1]})"]
        end

        # by_speciality.each do |speciality, contracts|
        #   d = ["#{speciality.new_code} #{speciality.name}", [0, 0], [0, 0], [0, 0]]
        #   contracts.each do |contract|
        #     case contract.student.group.form
        #     when 'fulltime' then d[1][0] += 1
        #     when 'semitime' then d[2][0] += 1
        #     when 'postal'   then d[3][0] += 1
        #     when 'distance' then d[3][0] += 1
        #     else fail 'Неизвестная форма обучения.'
        #     end
        #
        #     if contract.paid?
        #       case contract.student.group.form
        #       when 'fulltime' then d[1][1] += 1
        #       when 'semitime' then d[2][1] += 1
        #       when 'postal'   then d[3][1] += 1
        #       when 'distance' then d[3][1] += 1
        #       else fail 'Неизвестная форма обучения.'
        #       end
        #     end
        #   end
        #
        #   data_draft << d
        # end

        # data_draft.each do |el|
        #   data << [el[0], "#{el[1][0]} (#{el[1][1]})", "#{el[2][0]} (#{el[2][1]})", "#{el[3][0]} (#{el[3][1]})"]
        # end
      end

      @renderer.table data, column_widths: { 1 => 50, 2 => 60, 3 => 60 }
    end

    def contracts_by_direction
      @renderer.text('Распределение договоров по направлениям')

      data = [['Направление', 'Очная', 'Очно-заочная', 'Заочная']]
      @grouped_by_department.each do |abbreviation, contracts|
        # next unless 'ИПИТ' == abbreviation

        data << [{content: "[ #{abbreviation} ]", colspan: 4}]

        by_speciality = contracts.group_by do |contract|
          contract.student.group.speciality
        end

        data_draft = []
        by_speciality.each do |speciality, contracts|
          d = ["#{speciality.new_code} #{speciality.name}", [0, 0], [0, 0], [0, 0]]
          contracts.each do |contract|
            case contract.student.group.form
            when 'fulltime' then d[1][0] += 1
            when 'semitime' then d[2][0] += 1
            when 'postal'   then d[3][0] += 1
            when 'distance' then d[3][0] += 1
            else fail 'Неизвестная форма обучения.'
            end

            if contract.paid?
              case contract.student.group.form
                when 'fulltime' then d[1][1] += 1
                when 'semitime' then d[2][1] += 1
                when 'postal'   then d[3][1] += 1
                when 'distance' then d[3][1] += 1
                else fail 'Неизвестная форма обучения.'
              end
            end
          end

          data_draft << d
        end

        sorted_data = data_draft.sort_by do |row|
          parts = row[0].split('.')
          [parts[2][3..-1], parts[0], parts[1]]
        end

        sorted_data.each do |el|
          data << [el[0], "#{el[1][0]} (#{el[1][1]})", "#{el[2][0]} (#{el[2][1]})", "#{el[3][0]} (#{el[3][1]})"]
        end

        # data_draft.each do |el|
        #   data << [el[0], "#{el[1][0]} (#{el[1][1]})", "#{el[2][0]} (#{el[2][1]})", "#{el[3][0]} (#{el[3][1]})"]
        # end
      end

      @renderer.table data, column_widths: { 1 => 50, 2 => 60, 3 => 60 }
    end
  end
end
