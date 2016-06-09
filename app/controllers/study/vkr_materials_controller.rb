class Study::VkrMaterialsController < ApplicationController
  load_and_authorize_resource

  def download
    send_file @vkr_material.data.path(:original)
  end
end
