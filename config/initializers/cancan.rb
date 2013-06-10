module CanCan
  class ControllerResource
    def resource_params
      @controller.send(:resource_params)
    end
  end
end