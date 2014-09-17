module Office::OrderHelper
  def order_details(order)
    tags = []

    tags << order.students.count
    tags << ' '
    tags << Russian.p(order.students.count, 'студент', 'студента', 'студентов')

    tags.join
  end

  def link_for_order(order)
    options = { class: 'nowrap' }

    if order.template.current_xsl
      if order.draft?
        link_to edit_office_order_path(order), options do
          raw('<span class="glyphicon glyphicon-edit"></span> Редактировать')
        end
      else
        link_to office_order_path(order, format: :pdf), options do
          raw('<span class="glyphicon glyphicon-file"></span> Посмотреть')
        end
      end
    end
  end

  def order_number(order)
    if order.signed?
      "№#{order.number} от #{l(order.signing_date, format: '%d %B %Y')} (\##{order.id})"
    else
      "\##{order.id}"
    end
  end
end