Honeybadger.configure do |config|
  config.api_key = '23351d96'

  config.user_information = '<a href="https://www.honeybadger.io/notice/{{error_id}}">Подробная информация об ошибке</a>'.html_safe
end
