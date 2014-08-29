pdf.font_size 10

pdf.text "ДОГОВОР № #{@contract.number}",
         align: :center, style: :bold

pdf.font_size 8

pdf.text 'об образовании на обучение по образовательным программам высшего образования',
         align: :center, style: :bold, leading: 5

pdf.bounding_box([0, pdf.cursor], width: 510) do
  pdf.bounding_box([0, pdf.bounds.top], width: 250) do
    pdf.text 'г. Москва', indent_paragraphs: 15
  end
  pdf.bounding_box([260,  pdf.bounds.top], width: 250) do
    pdf.text "#{l(@contract.created_at.to_date, format: :long)} г.",
             align: :right
  end
end

pdf.move_down 5

if @contract.bilateral?
  #pdf.text "федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (МГУП имени Ивана Федорова), осуществляющее образовательную деятельность на основании лицензии от 11 августа 2011 г. серия ААА № 001773 (срок действия — бессрочно), выданной Федеральной службой по надзору в сфере образования и науки, именуемое в дальнейшем «Исполнитель», в лице начальника студенческого отдела кадров Бутаревой Ларисы Львовны, действующей на основании доверенности № 69/13 от 5 ноября 2013 года, и #{@entrant.full_name}, #{@entrant.male? ? 'именуемый' : 'именуемая'} в дальнейшем «Обучающийся», совместно именуемые «Стороны», заключили настоящий Договор о нижеследующем:",
  pdf.text "федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (МГУП имени Ивана Федорова), осуществляющее образовательную деятельность на основании лицензии от 11 августа 2011 г. серия ААА № 001773 (срок действия — бессрочно), выданной Федеральной службой по надзору в сфере образования и науки, именуемое в дальнейшем «Исполнитель», в лице проректора по административно-правовой работе и безопасности образовательного процесса Рачинского Дмитрия Васильевича, действующего на основании доверенности № 40/14 от 1 июня 2014 года, и #{@entrant.full_name}, #{@entrant.male? ? 'именуемый' : 'именуемая'} в дальнейшем «Обучающийся», совместно именуемые «Стороны», заключили настоящий Договор о нижеследующем:",
         align: :justify, indent_paragraphs: 15
elsif @contract.trilateral?
  #pdf.text "федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (МГУП имени Ивана Федорова), осуществляющее образовательную деятельность на основании лицензии от 11 августа 2011 г. серия ААА № 001773 (срок действия — бессрочно), выданной Федеральной службой по надзору в сфере образования и науки, именуемое в дальнейшем «Исполнитель», в лице начальника студенческого отдела кадров Бутаревой Ларисы Львовны, действующей на основании доверенности № 69/13 от 5 ноября 2013 года, и #{@contract.delegate_full_name}, именуемый в дальнейшем «Заказчик», и #{@entrant.full_name}, #{@entrant.male? ? 'именуемый' : 'именуемая'} в дальнейшем «Обучающийся», совместно именуемые «Стороны», заключили настоящий Договор о нижеследующем:",
  pdf.text "федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (МГУП имени Ивана Федорова), осуществляющее образовательную деятельность на основании лицензии от 11 августа 2011 г. серия ААА № 001773 (срок действия — бессрочно), выданной Федеральной службой по надзору в сфере образования и науки, именуемое в дальнейшем «Исполнитель», в лице проректора по административно-правовой работе и безопасности образовательного процесса Рачинского Дмитрия Васильевича, действующего на основании доверенности № 40/14 от 1 июня 2014 года, и #{@contract.delegate_full_name}, именуемый в дальнейшем «Заказчик», и #{@entrant.full_name}, #{@entrant.male? ? 'именуемый' : 'именуемая'} в дальнейшем «Обучающийся», совместно именуемые «Стороны», заключили настоящий Договор о нижеследующем:",
           align: :justify, indent_paragraphs: 15
else
  #pdf.text "федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (МГУП имени Ивана Федорова), осуществляющее образовательную деятельность на основании лицензии от 11 августа 2011 г. серия ААА № 001773 (срок действия — бессрочно), выданной Федеральной службой по надзору в сфере образования и науки, именуемое в дальнейшем «Исполнитель», в лице начальника студенческого отдела кадров Бутаревой Ларисы Львовны, действующей на основании доверенности № 69/13 от 5 ноября 2013 года, и #{@contract.delegate_organization}, именуемый в дальнейшем «Заказчик», в лице #{@contract.delegate_full_name}, #{@contract.delegate_position}, действующего на основании",
  pdf.text "федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (МГУП имени Ивана Федорова), осуществляющее образовательную деятельность на основании лицензии от 11 августа 2011 г. серия ААА № 001773 (срок действия — бессрочно), выданной Федеральной службой по надзору в сфере образования и науки, именуемое в дальнейшем «Исполнитель», в лице проректора по административно-правовой работе и безопасности образовательного процесса Рачинского Дмитрия Васильевича, действующего на основании доверенности № 40/14 от 1 июня 2014 года, и #{@contract.delegate_organization}, именуемый в дальнейшем «Заказчик», в лице #{@contract.delegate_full_name}, #{@contract.delegate_position}, действующего на основании",
           align: :justify, indent_paragraphs: 15, inline_format: true
  pdf.move_down 5
  pdf.line_width 0.2
  pdf.stroke_horizontal_rule
  pdf.move_down 4
  pdf.text "и #{@entrant.full_name}, #{@entrant.male? ? 'именуемый' : 'именуемая'} в дальнейшем «Обучающийся», совместно именуемые «Стороны», заключили настоящий Договор о нижеследующем:", align: :justify
end
pdf.move_down 5
pdf.text 'I. Предмет Договора', align: :center, style: :bold, leading: 5

forms = {
  10 => 'заочной',
  11 => 'очной',
  12 => 'очно-заочной'
}
pdf.text "1.1. Исполнитель обязуется предоставить образовательную услугу, а #{@contract.bilateral? ? 'Обучающийся' : 'Заказчик'} обязуется оплатить обучение Обучающегося по образовательной программе #{@application.direction.new_code} «#{@application.direction.name}» #{forms[@application.competitive_group_item.form]} формы обучения в пределах федерального государственного стандарта или образовательного стандарта в соответствии с учебными планами, в том числе индивидуальными, и образовательными программами Исполнителя.",
         align: :justify, indent_paragraphs: 15
pdf.text "1.2. Срок освоения образовательной программы (продолжительность обучения) в соответствии с учебным планом (размещен на официальном сайте Университета — www.mgup.ru) на момент подписания Договора составляет #{@contract.prices.size} #{Russian::p(@contract.prices.size, 'год', 'года', 'лет')}.",
         align: :justify, indent_paragraphs: 15
pdf.text '1.3.После освоения Обучающимся образовательной программы и успешного прохождения государственной итоговой аттестации ему выдается документ о высшем образовании и о квалификации. Обучающемуся, не прошедшему итоговой аттестации или получившему на итоговой аттестации неудовлетворительные результаты, а также Обучающемуся, освоившему часть образовательной программы и (или) отчисленному из МГУП имени Ивана Федорова, выдается справка об обучении или периоде обучения установленного образца.',
         align: :justify, indent_paragraphs: 15

pdf.move_down 5
pdf.text 'II. Взаимодействие сторон', align: :center, style: :bold, leading: 5

pdf.text '2.1. Исполнитель вправе:',
         align: :justify, indent_paragraphs: 15

pdf.text '2.1.1. Самостоятельно осуществлять образовательный процесс, устанавливать системы оценок, формы, порядок и периодичность промежуточной аттестации Обучающегося.',
         align: :justify, indent_paragraphs: 15

pdf.text '2.1.2. Применять к Обучающемуся меры поощрения и меры дисциплинарного взыскания в соответствии с законодательством Российской Федерации, учредительными документами Исполнителя, настоящим Договором и локальными нормативными актами Исполнителя.',
         align: :justify, indent_paragraphs: 15

pdf.text "2.1.3. Приостановить либо полностью отказаться, до устранения #{@contract.bilateral? ? 'Обучающимся' : 'Заказчиком'} указанных в настоящем пункте нарушений, от оказания образовательной услуги в случаях: отказа #{@contract.bilateral? ? 'Обучающегося' : 'Заказчика'} от оплаты, а также от предоставления копии платежных документов, несвоевременного сообщения об оплате, оплате без указания идентификатора (личного номера) Обучающегося.",
         align: :justify, indent_paragraphs: 15

pdf.text '2.1.4. Отчислить Обучающегося в случае просрочки оплаты очередного периода обучения, невыполнения учебного плана, за нарушение обязанностей, предусмотренных Уставом, Правилами внутреннего трудового и учебного распорядка, правилами проживания в общежитии, иных локальных актов МГУП имени Ивана Федорова.',
         align: :justify, indent_paragraphs: 15

pdf.text "2.2. #{@contract.bilateral? ? 'Обучающийся' : 'Заказчик'} вправе получать информацию от Исполнителя по вопросам организации и обеспечения надлежащего предоставления услуг, предусмотренных разделом I настоящего Договора, информацию об успеваемости, поведении, отношении Обучающегося к учебе в целом.",
         align: :justify, indent_paragraphs: 15

pdf.text '2.3. Обучающемуся предоставляются академические права в соответствии с частью 1 статьи 34 Федерального закона от 29 декабря 2012 г. № 273-ФЗ «Об образовании в Российской Федерации». Обучающийся также вправе:',
         align: :justify, indent_paragraphs: 15

pdf.text '2.3.1. Пользоваться в порядке, установленном локальными нормативными актами, имуществом Исполнителя, необходимым для освоения образовательной программы;',
         align: :justify, indent_paragraphs: 15

pdf.text '2.3.2. Принимать в порядке, установленном локальными нормативными актами, участие в социально-культурных, оздоровительных и иных мероприятиях, организованных Исполнителем;',
         align: :justify, indent_paragraphs: 15

pdf.text '2.3.3. Получать полную и достоверную информацию об оценке своих знаний, умений, навыков и компетенций, а также о критериях этой оценки.',
         align: :justify, indent_paragraphs: 15

pdf.text '2.4. Исполнитель обязан:',
         align: :justify, indent_paragraphs: 15

pdf.text '2.4.1. Зачислить Обучающегося, выполнившего установленные законодательством Российской Федерации, учредительными документами, локальными нормативными актами Исполнителя условия приема;',
         align: :justify, indent_paragraphs: 15

pdf.text "2.4.2. Довести до #{@contract.bilateral? ? 'Обучающегося' : 'Заказчика'} информацию, содержащую сведения о предоставлении платных образовательных услуг в порядке и объеме, которые предусмотрены Законом Российской Федерации от 7 февраля 1992 г. № 2300-1 «О защите прав потребителей» и Федеральным законом от 29 декабря 2012 г. № 273-ФЗ «Об образовании в Российской Федерации»;",
         align: :justify, indent_paragraphs: 15

pdf.text '2.4.3. Организовать и обеспечить надлежащее предоставление образовательных услуг, предусмотренных разделом I настоящего Договора. Образовательные услуги оказываются в соответствии с федеральным государственным образовательным стандартом или образовательным стандартом, учебным планом, в том числе индивидуальным, и расписанием занятий Исполнителя;',
         align: :justify, indent_paragraphs: 15

pdf.text '2.4.4. Обеспечить Обучающемуся предусмотренные выбранной образовательной программой условия ее освоения;',
         align: :justify, indent_paragraphs: 15

pdf.text "2.4.5. Принимать от #{@contract.bilateral? ? 'Обучающегося' : 'Заказчика'} плату за образовательные услуги;",
         align: :justify, indent_paragraphs: 15

pdf.text '2.4.6. Обеспечить Обучающемуся уважение человеческого достоинства, защиту от всех форм физического и психического насилия, оскорбления личности, охрану жизни и здоровья.',
         align: :justify, indent_paragraphs: 15

pdf.text "2.5. #{@contract.bilateral? ? 'Обучающийся' : 'Заказчик'} обязан:",
         align: :justify, indent_paragraphs: 15

pdf.text '2.5.1. Своевременно вносить плату за предоставляемые Обучающемуся образовательные услуги, указанные в разделе I настоящего Договора, в размере и порядке, определенными настоящим Договором.',
         align: :justify, indent_paragraphs: 15

pdf.text '2.5.2. В течение 3 (трех) рабочих дней с момента оплаты предоставить Исполнителю копии платежных документов, подтверждающих оплату.',
         align: :justify, indent_paragraphs: 15

pdf.text '2.6. Обучающийся обязан:',
         align: :justify, indent_paragraphs: 15

pdf.text '2.6.1. Соблюдать требования, установленные ст.43 Федерального закона от 29 декабря 2012 г. № 273-ФЗ «Об образовании в Российской Федерации»;',
         align: :justify, indent_paragraphs: 15

pdf.text '2.6.2. Своевременно предупреждать Исполнителя о причинах своего отсутствия на занятиях;',
         align: :justify, indent_paragraphs: 15

pdf.text '2.6.3. При отчислении по собственному желанию и (или) расторжении Договора по собственной инициативе, заблаговременно, не позднее 3 (трех) рабочих дней, письменно уведомить об этом Исполнителя;',
         align: :justify, indent_paragraphs: 15

pdf.text '2.6.4. В случае если Обучающийся отнесен к одной или нескольким категориям, указанным в ст. 27, 29 Федерального закона от 29 декабря 2012 г. № 273-ФЗ «Об образовании в Российской Федерации», вселиться в предоставленное ему для проживания общежитие не позднее сроков, указанных в локальных нормативных актах Исполнителя.',
         align: :justify, indent_paragraphs: 15

pdf.move_down 5
pdf.text 'III. Стоимость образовательных услуг, сроки и порядок их оплаты',
         align: :center, style: :bold, leading: 5

pdf.text "3.1. Полная стоимость образовательных услуг за весь период обучения Обучающегося составляет #{number_to_currency(@contract.total_price, unit: '', precision: 0)} (#{@contract.total_price.to_i.to_words}) рублей 0 копеек. Увеличение стоимости образовательных услуг после заключения настоящего Договора не допускается, за исключением увеличения стоимости указанных услуг с учетом уровня инфляции, предусмотренного основными характеристиками федерального бюджета на очередной финансовый год и плановый период.",
         align: :justify, indent_paragraphs: 15

pdf.text '3.2. Оплата производится в следующем порядке:',
         align: :justify, indent_paragraphs: 15

pdf.text '3.2.1. При очной и очно-заочной форме обучения оплата за первый семестр первого курса обучения первого учебного года производится в течение 3 (трех) рабочих дней с даты заключения настоящего Договора, но не позднее 19 августа 2014 года. За второй семестр первого курса обучения первого учебного года производится до 30 ноября 2014 года. Оплата за нечетные семестры каждого последующего курса обучения соответствующего учебного года производится до 30 апреля предыдущего учебного года. Оплата за четные семестры каждого последующего курса обучения соответствующего учебного года производится до 30 ноября текущего учебного года. ',
         align: :justify, indent_paragraphs: 15

pdf.text '3.2.2. При заочной форме обучения оплата за первый учебный год обучения производится течение 3 (трех) рабочих дней с даты заключения настоящего Договора, но не позднее 19 декабря 2014 года. Оплата каждого последующего учебного года обучения производится не позднее 30 января текущего учебного года.',
         align: :justify, indent_paragraphs: 15

pdf.text '3.2.3. Оплата образовательных услуг производится в соответствии с условиями, указанными в приложении №1 к настоящему Договору.',
         align: :justify, indent_paragraphs: 15

pdf.text "3.2.4. Оплата производится в безналичном порядке на расчетный счет Исполнителя. Оплата производится через уполномоченный банк Исполнителя (банковский терминал) с обязательным указанием идентификатора (личного номера) Обучающегося. В случае перечисления средств через иной банк, оплата стоимости банковских услуг (банковской комиссии и т.п.) по перечислению денежных средств, производится за счет #{@contract.bilateral? ? 'Обучающегося' : 'Заказчика'}.",
         align: :justify, indent_paragraphs: 15

pdf.text '3.3. В случае необходимости оказания Обучающемуся дополнительных образовательных услуг, не предусмотренных учебным планом, оплата указанных образовательных услуг производится на основании отдельно заключаемого Договора и в соответствии с действующими в МГУП имени Ивана Федорова расценками на соответствующие образовательные услуги.',
         align: :justify, indent_paragraphs: 15

pdf.text "3.4. В случае нарушения #{@contract.bilateral? ? 'Обучающимся' : 'Заказчиком'} сроков внесения оплаты за обучение, предусмотренных п.3.2. настоящего Договора, Исполнитель вправе взыскать с #{@contract.bilateral? ? 'Обучающегося' : 'Заказчика'} неустойку (пени) в размере 0,5 % подлежащей уплате суммы за каждый день просрочки. Начисление неустойки производится по факту несвоевременной оплаты из расчета количества дней просрочки оплаты от установленных Договором сроков. Оплата неустойки производится #{@contract.bilateral? ? 'Обучающимся' : 'Заказчиком'} в течение 10 (десяти) календарных дней с момента предъявления претензии, а в случае несвоевременного перечисления в указанный срок, Исполнитель вправе удержать сумму неустойки из суммы оплаты за обучение Обучающегося. Оплата неустойки не освобождает Стороны от выполнения обязательств по настоящему Договору.",
         align: :justify, indent_paragraphs: 15

pdf.text "3.5. В случае неисполнения или несвоевременного исполнения #{@contract.bilateral? ? 'Обучающимся' : 'Заказчиком'} обязательств по оплате обучения, Исполнитель вправе приостановить (полностью или частично) исполнение своих обязательств по оказанию образовательных услуг Обучающемуся.",
         align: :justify, indent_paragraphs: 15

pdf.text "3.6. В случае не поступления оплаты и (или) не предоставления подтверждающих оплату документов за обучение, указанных в пункте 3.2. настоящего Договора, Исполнитель вправе расторгнуть Договор и отчислить Обучающего из МГУП имени Ивана Федорова. В случае, если Обучающемуся образовательные услуги в вышеуказанный период были оказаны, Исполнитель вправе взыскать с #{@contract.bilateral? ? 'Обучающегося' : 'Заказчика'} стоимость фактически оказанных услуг с учетом требований пункта 3.4 Договора.",
         align: :justify, indent_paragraphs: 15

pdf.text '3.7. В случае расторжения Договора ранее внесенная оплата за не оказанные образовательные услуги возвращается в следующем порядке:',
         align: :justify, indent_paragraphs: 15

pdf.text "3.7.1. Расходы Исполнителя за оказанные Обучающемуся образовательные услуги подлежат оплате в соответствии с расчетом фактических расходов понесенных Исполнителем до момента расторжения Договора. Внесенная авансом оплата за обучение, превышающая размер фактических расходов Исполнителя, подлежит возврату #{@contract.bilateral? ? 'Обучающемуся' : 'Заказчику'}.",
         align: :justify, indent_paragraphs: 15

pdf.text "3.7.2. Для возврата денежных средств за неоказанные образовательные услуги #{@contract.bilateral? ? 'Обучающийся' : 'Заказчик'} предоставляет в бухгалтерию Исполнителя письменное заявление и документы по установленному перечню. Без предоставления необходимых документов возврат денежных средств не производится.",
         align: :justify, indent_paragraphs: 15

pdf.text "3.7.3. Возврат денежных средств за неоказанные образовательные услуги осуществляется в срок не более 90 (девяноста) дней с момента предоставления #{@contract.bilateral? ? 'Обучающимся' : 'Заказчиком'} заявления и документов, в соответствии с установленными бухгалтерией Исполнителя требованиями.",
         align: :justify, indent_paragraphs: 15

pdf.text '3.7.4. Срок возврата денежных средств исчисляется с даты издания приказа об отчислении Обучающегося при условии, что заявление о возврате денежных средств подано Исполнителю не позднее 3 (трех) дней с даты издания приказа. В случае, если заявление о возврате подано по истечении 3 (трех) дней с даты издания приказа, то срок возврата денежных средств исчисляется с момента подачи заявления о возврате денежных средств.',
         align: :justify, indent_paragraphs: 15

pdf.text '3.7.5. В случае, если Обучающийся не приступил к занятиям и не заявил о расторжении настоящего Договора, то образовательная услуга считается оказанной надлежащим образом и в необходимом объеме до момента расторжения Договора.',
         align: :justify, indent_paragraphs: 15

pdf.move_down 5
pdf.text 'IV. Порядок изменения и расторжения Договора',
         align: :center, style: :bold, leading: 5

pdf.text '4.1. Условия, на которых заключен настоящий Договор, могут быть изменены по соглашению Сторон или в соответствии с законодательством Российской Федерации.',
         align: :justify, indent_paragraphs: 15

pdf.text '4.2. Настоящий Договор может быть расторгнут по соглашению Сторон.',
         align: :justify, indent_paragraphs: 15

pdf.text '4.3. Настоящий Договор может быть расторгнут по инициативе Исполнителя в одностороннем порядке в случаях, предусмотренных пунктом 21 Правил оказания платных образовательных услуг, утвержденных постановлением Правительства Российской Федерации от 15 августа 2013 г. № 706.',
         align: :justify, indent_paragraphs: 15

pdf.text '4.4. Действие настоящего Договора прекращается досрочно:',
         align: :justify, indent_paragraphs: 15

pdf.text '— по инициативе Обучающегося или родителей (законных представителей) несовершеннолетнего Обучающегося, в том числе в случае перевода Обучающегося для продолжения освоения образовательной программы в другую организацию, осуществляющую образовательную деятельность;',
         align: :justify, indent_paragraphs: 15

pdf.text '— по инициативе Исполнителя в случае применения к Обучающемуся, достигшему возраста пятнадцати лет, отчисления как меры дисциплинарного взыскания, в случае невыполнения Обучающимся по профессиональной образовательной программе обязанностей по добросовестному освоению такой образовательной программы и выполнению учебного плана, а также в случае установления нарушения порядка приема в образовательную организацию, повлекшего по вине Обучающегося его незаконное зачисление в образовательную организацию;',
         align: :justify, indent_paragraphs: 15

pdf.text '— по обстоятельствам, не зависящим от воли Обучающегося или родителей (законных представителей) несовершеннолетнего Обучающегося и Исполнителя, в том числе в случае ликвидации Исполнителя.',
         align: :justify, indent_paragraphs: 15

pdf.text '4.5. Исполнитель вправе отказаться от исполнения обязательств по Договору при условии полного возмещения Обучающемуся убытков.',
         align: :justify, indent_paragraphs: 15

pdf.text '4.6. Обучающийся вправе отказаться от исполнения настоящего Договора при условии оплаты Исполнителю фактически понесенных им расходов.',
         align: :justify, indent_paragraphs: 15

pdf.move_down 5
pdf.text 'V. Ответственность Исполнителя и Обучающегося',
         align: :center, style: :bold, leading: 5

pdf.text '5.1. За неисполнение или ненадлежащее исполнение своих обязательств по Договору Стороны несут ответственность, предусмотренную законодательством Российской Федерации и настоящим Договором.',
         align: :justify, indent_paragraphs: 15

pdf.text '5.2. При обнаружении недостатка образовательной услуги, в том числе оказания не в полном объеме, предусмотренном образовательными программами (частью образовательной программы), Обучающийся вправе по своему выбору потребовать:',
         align: :justify, indent_paragraphs: 15

pdf.text '5.2.1. Безвозмездного оказания образовательной услуги.',
         align: :justify, indent_paragraphs: 15

pdf.text '5.2.2. Соразмерного уменьшения стоимости оказанной образовательной услуги.',
         align: :justify, indent_paragraphs: 15

pdf.text '5.2.3. Возмещения понесенных им расходов по устранению недостатков оказанной образовательной услуги своими силами или третьими лицами.',
         align: :justify, indent_paragraphs: 15

pdf.text "5.3. #{@contract.bilateral? ? 'Обучающийся' : 'Заказчик'} вправе отказаться от исполнения Договора и потребовать полного возмещения убытков, если в течение 90 (девяноста) дней недостатки образовательной услуги не устранены Исполнителем. #{@contract.bilateral? ? 'Обучающийся' : 'Заказчик'} также вправе отказаться от исполнения Договора, если им обнаружен существенный недостаток оказанной образовательной услуги или иные существенные отступления от условий Договора.",
         align: :justify, indent_paragraphs: 15

pdf.text "5.4. Если Исполнитель нарушил сроки оказания образовательной услуги (сроки начала и (или) окончания оказания образовательной услуги и (или) промежуточные сроки оказания образовательной услуги) либо если во время оказания образовательной услуги стало очевидным, что она не будет оказана в срок, #{@contract.bilateral? ? 'Обучающийся' : 'Заказчик'} вправе по своему выбору:",
         align: :justify, indent_paragraphs: 15

pdf.text '5.4.1. Назначить Исполнителю новый срок, в течение которого Исполнитель должен приступить к оказанию образовательной услуги и (или) закончить оказание образовательной услуги;',
         align: :justify, indent_paragraphs: 15

pdf.text '5.4.2. Поручить оказать образовательную услугу третьим лицам за разумную цену и потребовать от исполнителя возмещения понесенных расходов;',
         align: :justify, indent_paragraphs: 15

pdf.text '5.4.3. Потребовать уменьшения стоимости образовательной услуги;',
         align: :justify, indent_paragraphs: 15

pdf.text '5.4.4. Расторгнуть Договор.',
         align: :justify, indent_paragraphs: 15

pdf.move_down 5
pdf.text 'VI. Срок действия Договора',
         align: :center, style: :bold, leading: 5

pdf.text '6.1. Настоящий Договор вступает в силу со дня его заключения Сторонами и действует до полного исполнения Сторонами обязательств.',
         align: :justify, indent_paragraphs: 15

pdf.move_down 5
pdf.text 'VII. Заключительные положения',
         align: :center, style: :bold, leading: 5

pdf.text '7.1. Исполнитель вправе снизить стоимость платной образовательной услуги по Договору Обучающемуся, достигшему успехов в учебе и (или) научной деятельности, а также нуждающемуся в социальной помощи. Основания и порядок снижения стоимости платной образовательной услуги устанавливаются локальным нормативным актом Исполнителя и доводятся до сведения Обучающегося.',
         align: :justify, indent_paragraphs: 15

pdf.text '7.2. Сведения, указанные в настоящем Договоре, соответствуют информации, размещенной на официальном сайте Исполнителя в сети «Интернет» на дату заключения настоящего Договора.',
         align: :justify, indent_paragraphs: 15

pdf.text '7.3. Под периодом предоставления образовательной услуги (периодом обучения) понимается промежуток времени с даты издания приказа о зачислении Обучающегося в МГУП имени Ивана Федорова до даты издания приказа об окончании обучения или отчислении Обучающегося из МГУП имени Ивана Федорова.',
         align: :justify, indent_paragraphs: 15

pdf.text "7.4. Образовательные услуги в учебном семестре считаются оказанными надлежащим образом и в соответствующем объеме, если в течение семи календарных дней по окончании семестра Обучающийся#{' и (или) Заказчик' if @contract.trilateral?} не предъявит письменной претензии в связи с ненадлежащим оказанием образовательных услуг. Образовательные услуги считаются оказанными в полном объеме и надлежащего качества в соответствии с настоящим Договором в случае, если в течение семи календарных дней с момента издания приказа об отчислении Обучающийся#{' и (или) Заказчик' if @contract.trilateral?} не предъявит письменной претензии.",
         align: :justify, indent_paragraphs: 15

pdf.text "7.5. Настоящий Договор составлен в #{@contract.bilateral? ? 'двух' : 'трёх'} экземплярах, по одному для каждой из Сторон. Все экземпляры имеют одинаковую юридическую силу. Изменения и дополнения настоящего Договора могут производиться только в письменной форме и подписываться уполномоченными представителями Сторон.",
         align: :justify, indent_paragraphs: 15

pdf.text '7.6. Изменения Договора оформляются дополнительными соглашениями к Договору.',
         align: :justify, indent_paragraphs: 15

pdf.move_down 5
pdf.text 'VIII. Адреса и реквизиты Сторон',
         align: :center, style: :bold, leading: 5

pdf.bounding_box([0, pdf.cursor], width: 510) do
  first_box = pdf.bounding_box([0, pdf.bounds.top], width: (@contract.bilateral? ? 240 : 160)) do
    pdf.text 'ИСПОЛНИТЕЛЬ', style: :bold, leading: 5

    pdf.text <<-END
«МГУП имени Ивана Федорова»
127550, г. Москва, ул. Прянишникова, д. 2А
Телефон: +7 499 976-40-77
Факс: +7 499 976-06-35
ИНН: 7713059521
КПП: 771301001

Банковские реквизиты:
УФК по г. Москве (МГУП имени Ивана Федорова, л/с 20736У93920)
р/с № 40501810600002000079
Отделение 1 Москва
БИК 044583001
КБК 00000000000000000130
    END
  end
  university_height = first_box.height

  if @contract.trilateral?
    third_box = pdf.bounding_box([170,  pdf.bounds.top], width: 160) do
      pdf.text 'ЗАКАЗЧИК', style: :bold, leading: 5

      pdf.text <<-END
#{@contract.delegate_full_name}
Адрес: #{@contract.delegate_address}
Телефон: #{@contract.delegate_phone}
Паспорт #{@contract.delegate_pseries} #{@contract.delegate_pnumber} выдан #{l @contract.delegate_pdate} #{@contract.delegate_pdepartment}
      END
    end
    delegate_height = third_box.height
  elsif @contract.trilateral_with_organization?
    third_box = pdf.bounding_box([170,  pdf.bounds.top], width: 160) do
      pdf.text 'ЗАКАЗЧИК', style: :bold, leading: 5

      pdf.text <<-END
#{@contract.delegate_organization}, #{@contract.delegate_full_name}
Адрес: #{@contract.delegate_address}
Телефон: #{@contract.delegate_phone}
Моб. телефон: #{@contract.delegate_mobile}
Факс: #{@contract.delegate_fax}
ИНН: #{@contract.delegate_inn}
КПП: #{@contract.delegate_kpp}
л/с: #{@contract.delegate_ls}
БИК: #{@contract.delegate_bik}
      END
    end
    delegate_height = third_box.height
  end

  second_box = pdf.bounding_box([(@contract.bilateral? ? 280 : 340),  pdf.bounds.top], width: (@contract.bilateral? ? 240 : 160)) do
    pdf.text 'ОБУЧАЮЩИЙСЯ', style: :bold, leading: 5

    pdf.text <<-END
#{@entrant.full_name}
Дата рождения: #{l @entrant.birthday}
Место регистрации: #{[@entrant.azip, @entrant.aaddress].join(', ')}
Телефон: #{@entrant.phone}
Паспорт #{@entrant.pseries} #{@entrant.pnumber} выдан #{l @entrant.pdate} #{@entrant.pdepartment}
    END
  end
  entrant_height = second_box.height

  if @contract.trilateral? || @contract.trilateral_with_organization?
    pdf.move_down 10 + [university_height, entrant_height, delegate_height].max - entrant_height
  else
    pdf.move_down 10 + [university_height, entrant_height].max - entrant_height
  end

  pdf.bounding_box([0, pdf.cursor], width: 510) do
    pdf.bounding_box([0, pdf.bounds.top], width: 160) do
      # pdf.text '_____________________ Бутарева Л. Л.',
      pdf.text '_____________________ Рачинский Д. В.',
               indent_paragraphs: 15
    end
    if @contract.trilateral? || @contract.trilateral_with_organization?
      pdf.bounding_box([170, pdf.bounds.top], width: 160) do
        pdf.text "_____________________ #{@contract.delegate_short_name}",
                 indent_paragraphs: 15
      end
    end
    pdf.bounding_box([340,  pdf.bounds.top], width: 160) do
      pdf.text "_____________________ #{@entrant.short_name}",
               indent_paragraphs: 15
    end
  end
end

pdf.start_new_page

pdf.font_size 10

pdf.text 'ПРИЛОЖЕНИЕ № 1', align: :right, style: :bold

pdf.font_size 8
pdf.text "к договору № #{@contract.number} от #{l(@contract.created_at.to_date, format: :long)} г.",
         align: :right, style: :bold

pdf.font_size 10

pdf.move_down 10

pdf.text 'График платежей', align: :center

pdf.move_down 10

pdf.font_size 8

data = []
if 10 == @application.competitive_group_item.form
  data << ['Учебный год', 'Срок оплаты', 'Размер оплаты, руб.']
else
  data << ['Учебный год', 'Период оплаты', 'Срок оплаты', 'Размер оплаты, руб.']
end
@contract.prices.each_with_index do |price, index|
  if 10 == @application.competitive_group_item.form
    if 0 == index
      first_date = (@contract.created_at + 3.days).to_date
    else
      first_date = Date.new(price.entrance_year + index, 1, 30)
    end

    data << [
      "#{price.entrance_year + index}/#{price.entrance_year + index + 1}",
      "#{l(first_date, format: :long)} г.",
      number_to_currency(price.price)
    ]
  else
    if 0 == index
      first_date = (@contract.created_at + 3.days).to_date
    else
      first_date = Date.new(price.entrance_year + index, 4, 30)
    end

    second_date = Date.new(price.entrance_year + index, 11, 30)

    data << [
      "#{price.entrance_year + index}/#{price.entrance_year + index + 1}",
      "#{index * 2 + 1} семестр",
      "#{l(first_date, format: :long)} г.",
      number_to_currency(price.price / 2)
    ]

    data << [
      "#{price.entrance_year + index}/#{price.entrance_year + index + 1}",
      "#{index * 2 + 2} семестр",
      "#{l(second_date, format: :long)} г.",
      number_to_currency(price.price / 2)
    ]
  end
end

pdf.table data, width: 510