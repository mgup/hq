def find_applications(direction, form, source)
  form_method = case form
                    when 10
                      :z_form
                    when 12
                      :oz_form
                    else
                      :o_form
                  end
  payment_method = case source
                       when 15
                         :paid
                       else
                         :not_paid
                     end
  apps = Entrance::Application.
          joins(competitive_group_item: :direction).
          joins('LEFT JOIN entrance_benefits ON entrance_benefits.application_id = entrance_applications.id').
          send(form_method).send(payment_method).
          order('(entrance_benefits.benefit_kind_id = 1) DESC, entrance_applications.number ASC').where('directions.id = ?', direction)
  return apps
end

prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf
  key = false
  Direction.for_campaign(@campaign).each do |direction|
      EducationForm.all.each do |form|
        EducationSource.all.each do |source|
          applications = find_applications(direction.id, form.id, source.id)
          if applications.size > 0
            pdf.start_new_page if key
            key = true unless key
          else
            next
          end
          pdf.font_size 14 do
            pdf.text "Пофамильный список лиц, подавших документы, необходимые для поступления, по состоянию на #{l Time.now}."
          end
          pdf.stroke do
            pdf.horizontal_rule
          end
          pdf.move_down 5
          pdf.font_size 13 do
            pdf.text direction.department.name if direction.department
          end
          pdf.move_down 5
          pdf.font_size 12 do
            pdf.text "#{direction.new_code} #{direction.name}", style: :bold
            pdf.text "#{form.name}, #{Unicode::downcase(source.name)}", style: :bold
            pdf.move_down 5
            pdf.text "Подано #{applications.size} #{Russian::p(applications.size, 'заявление', 'заявления', 'заявлений')}."
          end
          data = [
            ['№', 'Регистрационный номер', 'Фамилия, имя, отчество', 'Основание приёма']
          ]
          applications.each_with_index do |application, index|
            row = [index + 1]
            row << application.number
            row << application.entrant.full_name
            row << application.entrance_type
            data << row
          end
          pdf.table data, header: true
        end
      end
  end
end