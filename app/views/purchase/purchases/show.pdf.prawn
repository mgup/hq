prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Отчет по расходованию средств по заявке на #{l(Date.today)}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  pdf.font_size 14 do
    if @purchase.number.present?
      pdf.text "Отчет по расходованию средств по заявке № #{@purchase.number} на #{l(Date.today)}", inline_format: true, align: :center, style: :bold
    else
      pdf.text "Отчет по расходованию средств по заявке на #{l(Date.today)}", inline_format: true, align: :center
    end
    pdf.text "#{@purchase.department.name}", inline_format: true, align: :center
  end
  pdf.move_down 20

  data = [ [ "#", "Товар", "Запланированно, руб.", "Период", "Остаток, руб.", "Котракты" ] ]
    @purchase.purchase_line_items.each_with_index do |p, index|
      data << [
          index + 1,
          p.purchase_goods.name,
          p.planned_sum,
          p.period,
          p.planned_sum - p.purchase_contract_items.collect { |li| li.total_price.to_i }.sum,
          if p.purchase_contract_items.present?
            p.purchase_contract_items.map { |ci| '№' + ci.purchase_contracts.number + ' от ' + l(ci.purchase_contracts.date_registration) }.join(", ")
          else
            'контракты отсутствуют'
          end
      ]
    end

  pdf.font_size 10 do
    pdf.table data, header: true do
      column(0).width = 20
      column(1).width = 140
      column(2).width = 80
      column(4).width = 80
      column(5).width = 120
    end
  end

end