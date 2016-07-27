if Rails.env.production?
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemcacheStore
end
