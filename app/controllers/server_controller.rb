class ServerController < ApplicationController
  def stats
    loads = %x(w | head -n1 | cut -d ":" -f 4)
  end

  def stats_load
    load1  = %x(cut -f 1 -d " " /proc/loadavg)
    load5  = %x(cut -f 2 -d " " /proc/loadavg)
    load15 = %x(cut -f 3 -d " " /proc/loadavg)
    render json: { load1: load1, load5: load5, load15: load15 }
  end

  def stats_memory
    total = %x(cat /proc/meminfo | grep MemTotal).split(':')[1].to_i
    active = %x(cat /proc/meminfo | grep Active:).split(':')[1].to_i
    render json: { total: total, active: active }
  end
end
