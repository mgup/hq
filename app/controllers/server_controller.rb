class ServerController < ApplicationController
  def stats
    loads = %x(w | head -n1 | cut -d ":" -f 4).split().map { |e| e.gsub(',', '.').to_f }

    # Для простоты ориентируемся на Linux-системы.
    total = %x(cat /proc/meminfo | grep MemTotal).split(':')[1].to_i
    active = %x(cat /proc/meminfo | grep Active:).split(':')[1].to_i

    render json: { load1:  loads[0], load5:  loads[1], load15: loads[2],
                   mem_total: total, mem_active: active }
  end
end
