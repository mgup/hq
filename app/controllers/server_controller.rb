class ServerController < ApplicationController
  def stats
    render json: Vmstat.load_average.to_h.merge(Vmstat.memory.to_h)
  end
end
