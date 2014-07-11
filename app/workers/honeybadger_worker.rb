class HoneybadgerWorker
  include Sidekiq::Worker

  def perform(notice)
    Honeybadger.sender.send_to_honeybadger(notice)
  end
end