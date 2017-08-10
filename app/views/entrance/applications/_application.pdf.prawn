pdf.font_size 10.5 do
      pdf.text "#{application.number}", align: :center, style: :bold
      pdf.move_down 5
      pdf.text 'Ректору федерального государственного бюджетного образовательного учреждения высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» профессору К.В. Антипову', inline_format: true
      pdf.text "от гр. <u>#{entrant.full_name}</u> <br>паспорт № #{entrant.pseries} #{entrant.pnumber}, выдан #{entrant.pdepartment} #{l entrant.pdate},", inline_format: true
      pdf.text "пол: #{entrant.female? ? 'женский' : 'мужской'}, дата рождения: #{l entrant.birthday}, место рождения: #{entrant.birth_place},"
      pdf.text "проживающ#{entrant.female? ? 'ей' : 'его'} по адресу #{entrant.azip} #{entrant.aaddress}.", inline_format: true

      pdf.move_down 5
      pdf.text 'ЗАЯВЛЕНИЕ', align: :center, style: :bold
      pdf.move_down 5

      pdf.text 'Прошу допустить меня к вступительным испытаниям и участию  в конкурсе'
      if Entrance::Application.from_aspirant.include? application
        pdf.text "на право поступления на обучение по программам подготовки научно-педагогических кадров в аспирантуре на направление подготовки (специальность): <u>#{application.competitive_group_item.direction.new_code}, «#{application.competitive_group_item.direction.name}»</u>", inline_format: true
      else
        pdf.text "на направление подготовки (специальность): <u>#{application.competitive_group_item.direction.new_code}, «#{application.competitive_group_item.direction.name}»</u>", inline_format: true
      end
      pdf.text "Форма обучения: <u>#{application.education_form_id == 10 ? 'заочная' : (application.education_form_id == 11 ? 'очная' : 'очно-заочная')}</u> Основа обучения: <u>#{application.is_payed ? 'по договорам' : 'бюджет'}</u>", inline_format: true
      pdf.text "В общежитии: <u>#{application.entrant.need_hostel? ? 'нуждаюсь' : 'не нуждаюсь'}</u>  Контактный/домашний телефон: <u>#{entrant.phone}</u> #{entrant.email}", inline_format: true
      pdf.text "#{entrant.female? ? 'Окончила' : 'Окончил'} #{entrant.edu_document.organization} в #{entrant.edu_document.graduation_year} г.<br>аттестат (диплом об окончании): <u>#{entrant.edu_document.series} № #{entrant.edu_document.number} от #{l entrant.edu_document.date}</u>", inline_format: true
      if Entrance::Entrant.aspirants.include? entrant
        pdf.text "присвоена квалификация: <u>#{entrant.edu_document.qualification}</u>", inline_format: true
      end
      pdf.text "С правилами приёма, Лицензией на право ведения образовательной деятельности <br>в сфере профессионального образования ААА № 001773 от 11.08.11, Свидетельством <br>о государственной аккредитации по выбранному направлению подготовки (специальности) <br>ВВ № 001559 от 19.03.12 ознакомлен#{'а' if entrant.female?}", inline_format: true
      pdf.text "__________________ / #{entrant.short_name} /", align: :right

      # pdf.move_down 4

      #только для бюджета (надо поставить условие)
      if application.competitive_group_item.budget_name == 'бюджет'
          pdf.text 'Получение высшего образования данного уровня впервые подтверждаю'
          pdf.text "__________________ / #{entrant.short_name} /", align: :right

          # pdf.move_down 4

          pdf.text "С датой представления оригинала документа государственного образца об образовании ознакомлен#{'а' if entrant.female?}"
          pdf.text "__________________ / #{entrant.short_name} /", align: :right
      else
        pdf.text "С датами завершения приема заявлений о согласии на зачисление ознакомлен#{'а' if entrant.female?}"
        pdf.text "__________________ / #{entrant.short_name} /", align: :right
      end


      #только бакалавры и специалисты (надо поставить условие)
      # pdf.move_down 4
      if application.competitive_group_item.direction.bachelor? || application.competitive_group_item.direction.specialist?
          pdf.text "С информацией о предоставляемых поступающим особых правах и преимуществах при приёме на обучение ознакомлен#{'а' if entrant.female?}"
          pdf.text "__________________ / #{entrant.short_name} /", align: :right
          pdf.text 'Подачу заявлений в не более, чем пять вузов подтверждаю'
          pdf.text "__________________ / #{entrant.short_name} /", align: :right
          pdf.text 'Подачу заявлений по не более, чем 3 направлениям подготовки (специальности) подтверждаю'
          pdf.text "__________________ / #{entrant.short_name} /", align: :right
      end


      # pdf.move_down 4

      pdf.text "С расписанием вступительных испытаний, правилами подачи апелляции ознакомлен#{'а' if entrant.female?}"
      pdf.text "__________________ / #{entrant.short_name} /", align: :right

      # pdf.move_down 4

      pdf.text "На обработку персональных данных, необходимых для проведения приёма и зачисления, соглас#{entrant.female? ? 'на' : 'ен'}"
      pdf.text "__________________ / #{entrant.short_name} /", align: :right

      # pdf.move_down 5
      pdf.move_down 3

      pdf.text "Гражданство: <u> <#{entrant.nationality_type.name} </u>", inline_format: true
      pdf.text "Отношение к военной службе: <u> #{entrant.military_status} </u>", inline_format: true
      if @campaign.id == 42016
        pdf.text "Наличие направления: <u> да </u>", inline_format: true
      else
        pdf.text "Наличие направления: <u> нет </u>", inline_format: true
      end

      if application.benefits.any?
        pdf.text "Категория зачисления: <u>#{Unicode::downcase(application.benefits.first.benefit_kind.name)}</u> (#{application.benefits.map(&:temp_text).join(' ')}).", inline_format: true
      elsif @campaign.id == 42016
        pdf.text 'Категория зачисления: <u> гослиния </u>', inline_format: true
      elsif application.competitive_group_target_item_id
        pdf.text "Категория зачисления: <u> по конкурсу целевого приёма по договору #{application.competitive_group_target_item.target_organization.contract_number} с  #{application.competitive_group_target_item.target_organization.name}</u>", inline_format: true
      else
        pdf.text 'Категория зачисления: <u> по конкурсу </u>', inline_format: true
      end

      if @campaign.id != 42016 || ([608, 685, 686, 197].include? application.competitive_group_item.direction.id)
        pdf.text 'Оценки для участия в конкурсе:'
        entrant.exam_results.in_competitive_group(application.competitive_group_item.competitive_group).each_with_index do |exam_result, index|
          result = ["#{index + 1}."]
          result << exam_result.exam.name
          result << "(#{exam_result.exam_type})"

          if application.benefits.first && application.benefits.first.benefit_kind.out_of_competition?
            result << ''
          else
            result << exam_result.score
          end

          pdf.text result.join(' ')
        end
      end


      if entrant.achievements.any?
        pdf.text 'Индивидуальные достижения:'
        entrant.achievements.each_with_index do |achievement, index|
          result = ["#{index + 1}."]
          result << achievement.achievement_type.institution_achievement.name
          result << achievement.document
          result << l(achievement.date) if achievement.date.present?
          # result << "(#{exam_result.exam_type})"

          # if application.benefits.first && application.benefits.first.benefit_kind.out_of_competition?
          #   result << ''
          # else
          #   result << exam_result.score
          # end

          pdf.text result.join(' ')
        end
      end





      pdf.move_down 4
      pdf.text 'Достоверность всех предоставленных сведений и подлинность документов подтверждаю.', align: :center
      pdf.move_down 6
      pdf.table [["#{l application.created_at, format: '%d %B %Y'} г.", {content:"___________________ / #{entrant.short_name} /", align: :right}]],
                width: pdf.bounds.width, cell_style: {border_color: 'ffffff'}

      pdf.move_down 5
      pdf.text '__________________ / __________________ / ', align: :right
      pdf.font_size 8 do
        pdf.indent 330 do
          pdf.text 'подпись ответственного секретаря'
        end
      end
    end

    pdf.start_new_page
    pdf.font_size 11 do
        pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ<br>ФГБОУ ВПО «МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ<br>ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center, style: :bold, inline_format: true

        pdf.move_down 8
        pdf.text "направление подготовки (специальность): <strong>#{application.competitive_group_item.direction.new_code}</strong>                     форма обучения: <strong>#{application.education_form_id == 10 ? 'заочная' : (application.education_form_id == 11 ? 'очная' : 'очно-заочная')}</strong>", inline_format: true
        pdf.move_down 8
        pdf.font_size 12 do
          pdf.text "ЭКЗАМЕНАЦИОННЫЙ ЛИСТ №#{application.number}", align: :center
        end
        pdf.move_down 5
        pdf.indent 20 do
            pdf.text "#{entrant.last_name} #{entrant.first_name} #{entrant.patronym}", inline_format: true
        end

        pdf.rectangle [0,670], 100, 130
        pdf.text_box 'место для фото', size: 9, at: [16,630], width: 70, height: 50

        pdf.text_box "#{l application.created_at, format: '%d %B %Y'} г.                      ___________________ / #{entrant.short_name} /", inline_format: true, at: [130,630], width: 600, height: 50

        pdf.move_down 140
        pdf.text 'Оценки вступительных испытаний', style: :bold, align: :center

        data = [['№ п/п', 'Наименование предмета (тип экзамена)', 'Дата экзамена', 'Оценка', 'Фамилия экзаменатора / сертификат ЕГЭ', 'Подпись экзаменатора']]
        sum = 0
        all = true
        entrant.exam_results.in_competitive_group(application.competitive_group_item.competitive_group).each_with_index do |exam_result, index|
          res = ["#{index + 1}."]
          res << "#{exam_result.exam.name} (#{exam_result.exam_type})"
          res << ''
          if application.benefits.first && application.benefits.first.benefit_kind.out_of_competition?
            res << ''
            all = false
          else
            res << exam_result.score

            if exam_result.score
              sum += exam_result.score
            else
              all = false
            end
          end
          res << ''
          res << ''

          data << res
        end

        total_sum = all ? sum : ''
        data << [{content: 'Общее количество баллов', colspan: 3}, total_sum]
        pdf.table data, header: true, cell_style: { padding: 2 } do
             column(0).width = 24
             column(1).width = 179.28
             column(2).width = 60
             column(3).width = 50
             column(4).width = 110
             column(5).width = 80
        end

        pdf.move_down 8
        pdf.text 'Ответственный секретарь приёмной комиссии                          ___________________ / ___________________ /'
        pdf.font_size 8 do
            pdf.indent 330 do
              pdf.text 'подпись ответственного секретаря'
            end
        end

        pdf.move_down 5

        pdf.stroke do
            pdf.move_down 4
            pdf.horizontal_rule
        end
        pdf.font_size 8 do
            pdf.text 'Линия отреза', align: :center
        end

        pdf.bounding_box([0, 270], width: 270, height: 240) do
            pdf.font_size 9 do
                pdf.text 'МИНИСТЕРСТВО', align: :center
                pdf.text 'ОБРАЗОВАНИЯ И НАУКИ', align: :center
                pdf.text 'РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
                pdf.move_down 10
                pdf.text 'федеральное государственное бюджетное', align: :center
                pdf.text 'образовательное учреждение', align: :center
                pdf.text 'высшего профессионального образования', align: :center
                pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ', align: :center
                pdf.text 'УНИВЕРСИТЕТ ПЕЧАТИ', align: :center
                pdf.text 'ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center
                pdf.move_down 10
                pdf.text 'Москва, 127550', align: :center
                pdf.text 'ул. Прянишникова, д. 2А', align: :center
                pdf.text 'тел. (499) 976-78-57', align: :center
                pdf.move_down 58
                pdf.indent 30 do
                  pdf.text "Сдал: ______________ / #{entrant.short_name} /", size: 9
                end
            end
        end

        pdf.bounding_box([250, 250], width: 260, height: 210) do
            pdf.text "Расписка № #{application.number}", style: :bold, align: :center, size: 11
            pdf.move_down 10
            pdf.font_size 10 do
                pdf.text "о приёме документов от поступающего на направление подготовки (специальность): #{application.competitive_group_item.direction.new_code}"
                pdf.text "Получены от #{entrant.short_name} следующие документы:"
                pdf.text '1. Заявление'
                pdf.text "2. Документ (#{application.original? ? 'подлинник' : 'копия'}) об образовании #{entrant.edu_document.series} № #{entrant.edu_document.number}, выданный #{entrant.edu_document.organization} #{l entrant.edu_document.date}", inline_format: true
                pdf.text '3. 2 фотокарточки 3х4'
                # pdf.text '4. Направление на целевой приём (нет)'
                pdf.text '4. Копия паспорта'
                pdf.text '5. Другое: __________________________'
                pdf.move_down 5
                pdf.text 'Принял: секретарь комиссии ________________ / ____________', size: 9
            end
        end

        pdf.move_down 8
        pdf.text "#{l application.created_at, format: '%d %B %Y'} г.", inline_format: true, size: 10

        unless entrant.papers.empty?
         pdf.start_new_page

         pdf.text 'СПИСОК НАУЧНЫХ ТРУДОВ', align: :center, style: :bold
         pdf.move_down 15
         pdf.text "#{entrant.full_name}"
         pdf.move_down 20

         paper_data = [['№ п/п', 'Наименование', 'Печатный или рукописный', 'Издательство, журнал (номер, год) или номер авторского свидетельства', 'Количество страниц', 'Фамилии соавторов']]
         entrant.papers.each_with_index do |paper, i|
            paper_data << [i+1, paper.name, (paper.printed ? 'печатный' : 'рукописный'), paper.publication, paper.lists, paper.co_authors]
         end

         pdf.font_size 9 do
             pdf.table paper_data, header: true do
                 column(1).width = 120
             end
         end
        end

    end
