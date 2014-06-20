pdf.font_size 11 do
      pdf.text "#{application.number}", align: :center, style: :bold
      pdf.move_down 5
      pdf.text 'Ректору <u>федерального государственного бюджетного образовательного учреждения высшего профессионального образования<br>«Московский государственный университет печати имени Ивана Федорова»<br>профессору К. В. Антипову</u>', inline_format: true, align: :center
      pdf.text "от гр. <u>#{entrant.full_name}</u>", inline_format: true
      pdf.text "паспорт № <u>#{entrant.pseries} #{entrant.pnumber}</u> выдан <u>#{entrant.pdepartment}</u>", inline_format: true
      pdf.text "дата выдачи <u>#{entrant.pdate}</u>", inline_format: true
      pdf.text "проживающ#{entrant.female? ? 'ей' : 'его'} по адресу <u>#{entrant.azip} #{entrant.aregion} #{entrant.aaddress}</u>", inline_format: true
      pdf.text "окончивш#{entrant.female? ? 'ей' : 'его'} <u>#{entrant.institution}</u> в <u>#{entrant.graduation_year} г.</u>", inline_format: true

      pdf.move_down 5
      pdf.text 'ЗАЯВЛЕНИЕ', align: :center, style: :bold
      pdf.move_down 5

      pdf.text 'Прошу допустить меня к вступительным испытаниям и участию  в конкурсе'
      pdf.text "на направление подготовки (специальность): <u>#{application.competitive_group_item.direction.code}.#{application.competitive_group_item.direction.qualification_code}, «#{application.competitive_group_item.direction.name}»</u>", inline_format: true
      pdf.text "Форма обучения: <u>#{application.competitive_group_item.form_name}</u> Основа обучения: <u>#{application.competitive_group_item.budget_name}</u>", inline_format: true
      pdf.text "В общежитии: <u>#{application.need_hostel? ? 'нуждаюсь' : 'не нуждаюсь'}</u>            Контактный/домашний телефон: <u>#{entrant.phone}</u>", inline_format: true
      pdf.text "О себе сообщаю следующие сведения:   пол: <u>#{entrant.female? ? 'женский' : 'мужской'}</u>, дата рождения: <u>#{l entrant.birthday}</u>,<br>место рождения: <u>#{entrant.birth_place}</u>", inline_format: true
      pdf.text "С правилами приёма, Лицензией на право ведения образовательной деятельности в сфере профессионального образования ААА № 001773 от 11.08.116 Свидетельством о государственной аккредитации по выбранному направлению подготовки (специальности) ВВ № 001559 от 19.03.12 ознакомлен#{'а' if entrant.female?}"
      pdf.text '__________________ / __________________ /', align: :right
      pdf.font_size 8 do
        pdf.indent 330 do
          pdf.text 'подпись поступающего'
        end
      end

      pdf.move_down 8

      #только для бюджета (надо поставить условие)
      if application.competitive_group_item.budget_name == 'бюджет'
          pdf.text 'Получение высшего образования данного уровня впервые подтверждаю'
          pdf.text '__________________ / __________________ /', align: :right
          pdf.font_size 8 do
            pdf.indent 330 do
              pdf.text 'подпись поступающего'
            end
          end
      end


      #только бакалавры и специалисты (надо поставить условие)
      pdf.move_down 4
      if application.competitive_group_item.direction.qualification_code == 62 || application.competitive_group_item.direction.qualification_code == 65
          pdf.text 'Подачу заявлений в не более, чем пять вузов подтверждаю'
          pdf.text '__________________ / __________________ /', align: :right
          pdf.font_size 8 do
            pdf.indent 330 do
              pdf.text 'подпись поступающего'
            end
          end
      end

      pdf.move_down 4

      pdf.text "С датой представления оригинала документа государственного образца об образовании ознакомлен#{'а' if entrant.female?}"
      pdf.text '__________________ / __________________ /', align: :right
      pdf.font_size 8 do
        pdf.indent 330 do
          pdf.text 'подпись поступающего'
        end
      end

      pdf.move_down 4

      pdf.text "С расписанием вступительных испытаний, правилами подачи апелляции ознакомлен#{'а' if entrant.female?}"
      pdf.text '__________________ / __________________ /', align: :right
      pdf.font_size 8 do
        pdf.indent 330 do
          pdf.text 'подпись поступающего'
        end
      end

      pdf.move_down 4

      pdf.text "На обработку персональных данных, необходимых для проведенияприёма и зачисления, соглас#{entrant.female? ? 'на' : 'ен'}"
      pdf.text '__________________ / __________________ /', align: :right
      pdf.font_size 8 do
        pdf.indent 330 do
          pdf.text 'подпись поступающего'
        end
      end

      pdf.move_down 5

      pdf.text "Гражданство: <u> <#{entrant.citizen_name} </u>", inline_format: true
      pdf.text "Отношение к военной службе: <u> #{entrant.military_status} </u>", inline_format: true
      pdf.text "Наличие направления: <u> нет </u>", inline_format: true
      pdf.text "Категория зачисления: <u> по конкурсу </u>", inline_format: true
      pdf.text 'Оценки для участия в конкурсе:'
      entrant.exam_results.each_with_index do |exam_result, index|
        pdf.text "#{index+1}. #{exam_result.exam.name} (#{exam_result.exam_type}) - #{exam_result.score}"
      end

      pdf.move_down 4
      pdf.text 'Достоверность всех предоставленных сведений и подлинность документов подтверждаю.', align: :center
      pdf.move_down 6
      pdf.text "«<u>#{l application.created_at, format: '%d'}</u>» <u>#{l application.created_at, format: '%B'}</u> <u>#{l application.created_at, format: '%Y'}</u> г.                                                                                         ___________________ / __________________ /", inline_format: true
      pdf.font_size 8 do
        pdf.indent 330 do
          pdf.text 'подпись поступающего'
        end
      end

      pdf.move_down 5
      pdf.text '__________________ / __________________ /', align: :right
      pdf.font_size 8 do
        pdf.indent 330 do
          pdf.text 'подпись ответственного секретаря'
        end
      end
    end

    pdf.start_new_page
    pdf.font_size 11 do
        pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ<br>ФГБУ ВПО «МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ<br>ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center, style: :bold, inline_format: true
       

        pdf.move_down 8
        pdf.text "направление подготовки (специальность): <strong>#{application.competitive_group_item.direction.code}.#{application.competitive_group_item.direction.qualification_code}</strong>                     форма обучения: <strong>#{application.competitive_group_item.form_name}</strong>", inline_format: true
        pdf.move_down 8
        pdf.font_size 12 do
          pdf.text "ЭКЗАМЕНАЦИОННЫЙ ЛИСТ №#{application.number}", align: :center
        end
        pdf.move_down 5
        pdf.indent 20 do
            pdf.text "Фамилия <u>#{entrant.last_name}<u>", inline_format: true
            pdf.text "Имя <u>#{entrant.first_name}<u> Отчество <u>#{entrant.patronym}<u>", inline_format: true
        end

        pdf.rectangle [0,640], 100, 130
        pdf.text_box 'место для фото', size: 9, at: [16,630], width: 70, height: 50

        pdf.text_box "«<u>#{l application.created_at, format: '%d'}</u>» <u>#{l application.created_at, format: '%B'}</u> <u>#{l application.created_at, format: '%Y'}</u> г.                                  ___________________ / __________________ /", inline_format: true, at: [130,630], width: 600, height: 50

        pdf.move_down 140
        pdf.text 'Оценки вступительных испытаний', style: :bold, align: :center

        data = [['№ п/п', 'Наименование предмета (тип экзамена)', 'Дата экзамена', 'Оценка', 'Фамилия экзаменатора / сертификат ЕГЭ', 'Подпись экзаменатора']]
        sum = 0
        entrant.exam_results.each_with_index do |exam_result, index|
            data << ["#{index+1}.", "#{exam_result.exam.name} (#{exam_result.exam_type})", '', exam_result.score, '', '']
            sum += exam_result.score
        end
        data << [{content: 'Общее количество баллов', colspan: 3}, sum]
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

        pdf.move_down 20

        pdf.stroke do
            pdf.move_down 8
            pdf.horizontal_rule
        end
        pdf.font_size 8 do
            pdf.text 'Линия отреза', align: :center
        end

        pdf.bounding_box([0, 260], width: 200, height: 220) do
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
            end
        end

        pdf.bounding_box([250, 260], width: 250, height: 220) do
            pdf.text "Расписка № #{application.number}", style: :bold, align: :center, size: 11
            pdf.move_down 15
            pdf.font_size 10 do
                pdf.text "о приёме документов от пуступающего на направление подготовки (специальность): #{application.competitive_group_item.direction.code}.#{application.competitive_group_item.direction.qualification_code}"
                pdf.text "Получены от #{entrant.short_name} следующие документы:"
                pdf.text '1. Заявление'
                pdf.text "2. Документ (#{application.original? ? 'подлинник' : 'копия'}) об образовании, выданный <u>#{entrant.institution}</u>", inline_format: true
                pdf.text '3. 4 фотокарточки 3х4'
                # pdf.text '4. Направление на целевой приём (нет)'
                pdf.text '4. Копия паспорта'
                pdf.text '5. Другое: __________________________'
            end
        end

        pdf.text "Сдал: ______________ / #{entrant.short_name} /                   Принял: секретарь комиссии ______________ / ___________________ /", size: 10
        pdf.move_down 8
        pdf.text "«<u>#{l application.created_at, format: '%d'}</u>» <u>#{l application.created_at, format: '%B'}</u> <u>#{l application.created_at, format: '%Y'}</u> г.", inline_format: true, size: 10

    end