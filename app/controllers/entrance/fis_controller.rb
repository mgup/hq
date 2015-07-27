class Entrance::FisController < ApplicationController
  require 'csv'
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'

  def test
    raise 'Тестовая ошибка'

    FISRequestWorker.perform_async('test')

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.Root do
        xml.AuthData do
          xml.Login ENV['FIS_LOGIN']
          xml.Pass  ENV['FIS_PASSWORD']
        end
        xml.GetDictionaryContent do
          xml.DictionaryCode 10
        end
      end
    end

    def kladr
      @entrants = @campaign.entrants
    end

    # http = Net::HTTP.new(ENV['FIS_HOST'], port: ENV['FIS_PORT'])
    # @response = http.post('/import/ImportService.svc/dictionarydetails', doc)

    @response = HTTParty.post(
      'http://priem.edu.ru:8000/import/ImportService.svc/dictionarydetails',
      body: builder.to_xml,
      headers: {'Content-type' => 'text/xml'}
    )
  end

  # Формирование запроса на удаление из ФИС всех заявлений,
  # которые мы туда добавляли.
  def clear
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.comment 'Удаление всех заявлений.'
      xml.Root do
        xml.AuthData do
          xml.Login ENV['FIS_LOGIN']
          xml.Pass  ENV['FIS_PASSWORD']
        end
        xml.DataForDelete do
          xml.Applications do
            if params[:fis_clear]
              file_data = params[:fis_clear].tempfile
              content = Nokogiri::XML(file_data)
              content.css('Application').each do |node|
                xml.Application do
                  xml.ApplicationNumber node.xpath('ApplicationNumber').inner_text
                  xml.RegistrationDate  node.xpath('RegistrationDate').inner_text
                end
              end
            end
          end
        end
      end
    end
    doc = builder.doc
    doc.encoding = 'utf-8'
    @xml = doc.to_xml

    respond_to do |format|
      format.html
      # format.xml { render xml: builder.doc.to_xml }
    end
  end

  def clear_check
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.comment 'Проверка результата удаления данных.'
      xml.Root do
        xml.AuthData do
          xml.Login ENV['FIS_LOGIN']
          xml.Pass  ENV['FIS_PASSWORD']
        end
        xml.GetResultDeleteApplication do
          xml.PackageID params[:id]
        end
      end
    end

    respond_to do |format|
      format.xml { render xml: builder.doc.to_xml }
    end
  end

  # Пакетная проверка результатов ЕГЭ.
  def check_use
    respond_to do |format|
      format.html
      format.csv do
        send_data (params[:new_entrants] ? @campaign.entrants.without_checks.as_csv : @campaign.entrants.as_csv)
      end
    end
  end

  def check
    file_data = params[:fis_check] || params[:fis_empty_check]

    if file_data
      # Парсим ответ от ФИС, исключаем из выдачи недействительные результаты
      # и формируем хэш с понятными названиями полей.
      headers = [:last_name, :first_name, :patronym, :pseries, :pnumber,
                 :exam_name, :score, :year, :f8, :f9, :f10, :number, :f12]
      r = CSV.parse(
        file_data.read.force_encoding('Windows-1251').encode('UTF-8'),
        col_sep: '%', skip_lines: /^((?!Действующий).)*$/
      ).map { |row| Hash[headers.zip(row)] }

      # Выполняем проверку для всех абитуриентов или только для непроверенных.
      entrants = if params[:fis_check]
                   @campaign.entrants
                 elsif params[:fis_empty_check]
                   @campaign.entrants.without_checks
                 end

      # Группируем результаты по серии и номеру документа.
      r.group_by { |h| h.values_at(:pseries, :pnumber) }.each do |pdata, scores|
        # Находим нужного абитуриента и делаем запись о проверке.
        entrant = entrants.find_by_pseries_and_pnumber(*pdata)
        if entrant
          check = entrant.checks.create(date: Date.today)

          # Для каждого результата проверяем совпадение баллов с записанными
          # у нас и сохраняем баллы в информацию о проверке.
          scores.each do |subject|
            # Информация о результатах ЕГЭ по дисциплине, полученная из ФИС.
            if 'Английский язык' == subject[:exam_name]
              subject[:exam_name] = 'Иностранный язык'
            end

            data = { exam_name: subject[:exam_name],
                     score: subject[:score],
                     year: subject[:year] }

            results = entrant.exam_results.use.by_exam_name(subject[:exam_name])
            if results.size > 1
              fail "У абитуриента #{entrant.full_name} дублируются экзамены."
            elsif results.any?
              result = results.first

              # Если наш результат не совпадает с полученным от ФИС, то меняем
              # наш на результат из ФИС, сохраняя при этом старое значение.
              if result.score != subject[:score].to_i
                result.old_score = result.score
                result.score = subject[:score]
              end
              result.checked = true
              result.checked_at = DateTime.now
              result.save!

              data[:exam_result_id] = result.id
            end

            check.results.create(data)
          end
        end
      end

      # Ищем абитуриентов, у которых были пустые проверки или у которых
      # ещё не было ни одной проверки. Если в результатах от ФИС их нет,
      # то создаём для них пустую проверку.
      grouped_results = r.group_by { |h| h.values_at(:pseries, :pnumber) }
      entrants.each do |e|
        unless grouped_results.find_all { |pdata, _| pdata == [e.pseries, e.pnumber] }.any?
          e.checks.create(date: Date.today)
        end
      end
    end

    redirect_to entrance_campaign_fis_check_use_path, notice: 'Проверка завершена'
  end
end