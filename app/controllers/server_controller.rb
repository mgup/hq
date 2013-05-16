class ServerController < ApplicationController
  def load_average_1
    load = %x(cut -f 1 -d " " /proc/loadavg)
    render json: { load: load }
  end

  def load_average_5
    load = %x(cut -f 2 -d " " /proc/loadavg)
    render json: { load: load }
  end

  def load_average_15
    load = %x(cut -f 3 -d " " /proc/loadavg)
    render json: { load: load }
  end

  def active_memory
  end
end
