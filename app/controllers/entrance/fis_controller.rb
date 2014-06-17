class Entrance::FisController < ApplicationController
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
end