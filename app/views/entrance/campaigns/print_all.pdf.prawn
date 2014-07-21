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
  if @department
    directions = Direction.not_aspirants.from_department(@department.id).for_campaign(@campaign)
  elsif @for_aspirants
    directions = Direction.for_aspirants.for_campaign(@campaign)
  end
  key = false
    directions.each do |direction|
      EducationForm.find_each do |form|
        [[14, 'бюджетные места'],[15, 'с оплатой обучения']].each do |source|
          applications = find_applications(direction.id, form.id, source[0])
          if applications.size > 0
            pdf.start_new_page if key
            unless key
              key = true
            end
          else
            next
          end
          pdf.font_size 12 do
          pdf.text "Пофамильный список лиц, подавших документы, необходимые для поступления, по состоянию на #{l Time.now}."
          end
          pdf.stroke do
            pdf.horizontal_rule
          end
          pdf.move_down 5
          pdf.font_size 12 do
            pdf.text "#{@department ? @department.abbreviation : 'Аспирантура'}"
          end
          pdf.move_down 20
          pdf.font_size 10 do
            pdf.text "#{direction.new_code} #{direction.name}, #{Unicode::downcase(form.name)}, #{Unicode::downcase(source[1])}", style: :bold
            pdf.move_down 5
            pdf.text "Подано #{applications.size} #{Russian::p(applications.size, 'заявление', 'заявления', 'заявлений')}."
          end
          pdf.move_down 5
          pdf.font_size 9 do
            applications.each_with_index do |application, index|
              pdf.text "#{index + 1}. #{application.number}, #{application.entrant.full_name}, #{application.entrance_type}"
            end
          end
        end
      end
  end
end