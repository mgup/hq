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

  # Алгоритм формирования отчёта.
  def _render
    @renderer.title(self)
    @renderer.text(txt_general_info)
    @renderer.image(graph_received_expected_sums)
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
    g = Gruff::SideBar.new('800x175')
    g.font = ::Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf').to_s
    g.theme = { colors: %w(#000000 #444444 #666666 #888888 #aaaaaa #cccccc),
                marker_color: '#aea9a9',
                font_color: 'black',
                background_colors: 'white' }
    # g.title = 'Поступившие платежи'
    g.right_margin = 100
    g.legend_font_size = 12
    g.marker_font_size = 12
    g.data('Поступившие платежи, руб.',
           [received_for_first_term_sum])
    g.data('Суммарный первый обязательный платёж, руб.',
           [expected_for_first_term_sum])
    g.minimum_value = 0
    g.labels = { 0 => ' ' }
    g.show_labels_for_bar_values = true

    g.to_blob('PNG')
  end

  def txt_general_info
    txt = ["Всего заключено #{contracts_count}"]
    txt << Russian::p(contracts_count, 'договор', 'договора', 'договоров')
    txt << 'об образовании на общую сумму'
    txt << number_to_currency(total_sum).gsub(' ', ' ')

    if payed_contracts_count > 0
      txt << "Из них по #{payed_contracts_count}"
      txt << Russian::p(payed_contracts_count,
                        'договору', 'договорам', 'договорам')
      txt << 'уже полностью поступил первый обязательный платёж.'
    else
      txt << 'Ни по одному договору ещё полностью не поступил'
      txt << 'первый обязательный платёж.'
    end

    txt.join(' ')
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