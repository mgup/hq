class Study::VkrsController < ApplicationController
  load_and_authorize_resource

  def index
    @user = current_user
    # @user = User.find_by(id: 1331)

    @position = @user.positions.from_role(:sekretar_gek).first
    @secretaries = @position.sekretar_gek
    @groups = @secretaries.map { |s| s.group }
  end
end
