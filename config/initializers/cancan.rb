module CanCan
  class ControllerResource
    def resource_params
      @controller.send(:resource_params)
    end
  end

  # Этот monkey-patch необходим для того, чтобы в Rollbar не отправлялись
  # сообщения об ошибках в том случае, если ресурс был не найден. Эту ошибку
  # могут вызвать всякие разные роботы и нам не очень важно все их видеть.
  # Если ресурс не найден, то значит просто не надо было заходить по этому
  # адресу.
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