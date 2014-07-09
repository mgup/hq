class Entrance::FisController < ApplicationController
  require 'csv'
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'

  def test
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
  end

  def check
    if params[:fis_check]
      file_data = params[:fis_check]
      content = CSV.parse(file_data.read.force_encoding('windows-1251').encode('UTF-8'))

      results = []
      content.each do |row|
        a = row.join.split('%')
        next if a[9] != 'Действующий'
        results << {last_name: Unicode::capitalize(a[0]), pseries: a[3], pnumber: a[4], exam_name: a[5], score: a[6], year: a[7].to_i, number: a[11]}
      end
      results.group_by { |h| h.values_at(:last_name, :pseries, :pnumber, :exam_name) }.map{ |_, v| v.max_by { |h| h[:year] }}.each do |r|
        entrant = @campaign.entrants.filter(pseries: r[:pseries], pnumber: r[:pnumber], last_name: r[:last_name]).last
        if entrant
          if Entrance::UseCheck.last.entrant == entrant
            check = Entrance::UseCheck.last
          else
            check = Entrance::UseCheck.create date: Date.today, number: r[:number], year: r[:year], entrant_id: entrant.id
          end
          result = entrant.exam_results.from_exam_name(r[:exam_name]).use.last
          if result
            if result.score != r[:score].to_i
              result.old_score = result.score
              result.score = r[:score].to_i
              result.checked = true
              result.checked_at = DateTime.now
              result.save
            else
              result.checked = true
              result.checked_at = DateTime.now
              result.save
            end
            Entrance::UseCheckResult.create exam_name: r[:exam_name], score: r[:score].to_i,
                                                   exam_result_id: result.id, use_check_id: check.id
          else
            Entrance::UseCheckResult.create exam_name: r[:exam_name], score: r[:score].to_i,
                                                   use_check_id: check.id
          end
        else
          next
        end
      end
      @campaign.entrants.select {|e| e.checks.collect{|c| c.results.count}.sum == 0 }.each do |entrant|
        Entrance::UseCheck.create date: Date.today, entrant_id: entrant.id
      end
      @campaign.entrants.select {|e| e.checks.count == 0 }.each do |entrant|
        Entrance::UseCheck.create date: Date.today, entrant_id: entrant.id
      end
    end
    redirect_to entrance_campaign_fis_check_use_path, notice: 'Проверка завершена'
  end
end