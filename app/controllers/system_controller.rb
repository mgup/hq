class SystemController < ApplicationController
  def stats
    stats = Hash.new
    stats.merge! Vmstat.load_average.to_h
    stats.merge! Vmstat.memory.to_h
    stats.merge! Vmstat.disk('/').to_h

    render json: stats
  end
end
