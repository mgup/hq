class Study::VkrsController < ApplicationController
  load_and_authorize_resource

  def index
    @user = current_user
    # @user = User.find_by(id: 1331)

    @position = @user.positions.from_role(:sekretar_gek).first

    if @position.present?
      @secretaries = @position.sekretar_gek
      @groups = @secretaries.map { |s| s.group }
    else
      redirect_to root_path, notice: 'У вас пока что нет прав доступа'
    end
  end
end
