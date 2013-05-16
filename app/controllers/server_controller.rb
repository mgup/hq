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
    total = %x(cat /proc/meminfo | grep MemTotal).split(':')[1].to_i
    active = %x(cat /proc/meminfo | grep Active:).split(':')[1].to_i
    render json: { total: total, active: active }
  end
end
