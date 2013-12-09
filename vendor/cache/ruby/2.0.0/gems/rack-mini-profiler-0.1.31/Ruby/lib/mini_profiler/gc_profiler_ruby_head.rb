require 'objspace'

class Rack::MiniProfiler::GCProfilerRubyHead
  def profile_rack(app,env)
  end

  def profile(&block)
    GC.start
    GC.disable

    items = []
    objs = []

    ObjectSpace.trace_object_allocations do
      block.call

      ObjectSpace.each_object do |o|
        objs << o
      end

      objs.each do |o|
        g = ObjectSpace.allocation_generation(o)
        if g
          l = ObjectSpace.allocation_sourceline(o)
          f = ObjectSpace.allocation_sourcefile(o)
          c = ObjectSpace.allocation_class_path(o)
          m = ObjectSpace.allocation_method_id(o)
          items << "Allocated #{c} in #{m} #{f}:#{l}"
        end
      end
    end

    items.group_by{|x| x}.sort{|a,b| b[1].length <=> a[1].length}.each do |row, group|
      puts "#{row} x #{group.length}"
    end

    GC.enable
    profile_allocations(name, &block)
  end
end
