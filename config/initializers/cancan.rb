module CanCan
  class ControllerResource
    def resource_params
      @controller.send(:resource_params)
    end
  end

  module ModelAdapters
    class ActiveRecordAdapter < AbstractAdapter
      def self.find(model_class, id)
        Rollbar.silenced do
          model_class.find(id)
        end
      end
    end
  end
end