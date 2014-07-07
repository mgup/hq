class Entrance::FisController < ApplicationController
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
            @campaign.applications.each do |appl|
              xml.Application do
                xml.ApplicationNumber appl.number
                xml.RegistrationDate  appl.created_at.iso8601
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
end