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

  def create
    respond_to do |format|
      format.js do
        @vkr.save!

        @student = @vkr.student
      end
    end
  end

  def update
    respond_to do |format|
      format.js do
        @vkr.update!(resource_params)

        @student = @vkr.student
      end
    end
  end

  def resource_params
    params.fetch(:study_vkr, {}).permit(:student_id, :title,
                                        materials_attributes: [:id, :data, :_destroy])
  end
end
