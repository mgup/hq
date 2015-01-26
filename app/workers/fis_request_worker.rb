class FISRequestWorker
  include Sidekiq::Worker

  def perform(body)
    puts body

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.Root do
        xml.AuthData do
          xml.Login 'eurer@mail.ru'
          xml.Pass  'GwpQ6tE'
        end
        xml.GetDictionaryContent do
          xml.DictionaryCode 10
        end
      end
    end

    response = HTTParty.post(
      'http://priem.edu.ru:8000/import/ImportService.svc/dictionarydetails',
      body: builder.to_xml,
      headers: { 'Content-Type' => 'text/xml' }
    )

    raise response.inspect
  end
end