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

  data = [ [ "", "",  {:content => "Запланированно", :colspan => 2}, {:content => "Остаток", :colspan => 2 }, "" ],
           [ "#", "Товар", "Сумма, руб.", "Период, мес.", "Сумма, руб.", "Период, мес.", "Котракты" ] ]
    @purchase.purchase_line_items.each_with_index do |p, index|
      data << [
          index + 1,
          p.purchase_goods.name,
          p.planned_sum,
          p.period.to_i,
          p.planned_sum - p.purchase_contract_items.collect { |li| li.total_price.to_i }.sum,
          p.period.to_i - p.purchase_contract_items.collect { |li| li.contract_time.to_i }.sum,
          if p.purchase_contract_items.present?
            p.purchase_contract_items.map { |ci| '№' + ci.purchase_contracts.number + ' от ' + l(ci.purchase_contracts.date_registration) }.join(", ")
          else
            'контракты отсутствуют'
          end
      ]
    end

  last_cell = @purchase.purchase_line_items.count + 2
  planned_price = @purchase.purchase_line_items.collect { |li| li.planned_sum.to_i }.sum
  amount_price =  @purchase.purchase_contract_items.collect { |li| li.total_price.to_i }.sum

  data << [ "", "Всего",
            planned_price,
            "",
            planned_price - amount_price,
            "", ""]


  #data << [ [ {content: 'Всего:', colspan: 2 }, @purchase.purchase_line_items.collect { |li| li.planned_sum.to_i }.sum , "", "", "", "" ] ]

  pdf.font_size 10 do
    pdf.table data do
      for i in 0..1 do
        row(i).font_style = :bold
        row(i).align = :center
      end
      row(last_cell).font_style = :bold
    end
  end

end