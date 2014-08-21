Honeybadger.configure do |config|
  config.api_key = '23351d96'

  config.async do |notice|
    HoneybadgerWorker.perform_async(notice.to_json)
  end
end
