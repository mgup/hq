class Entrance::AchievementsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :campaign, class: 'Entrance::Achievement', except: [:index]
  
  def index
    if params[:achievement_type_id]
      found = false
      if @campaign.achievement_types.any?
        @campaign.achievement_types.each do |achievement_type|
          found = true if achievement_type.id == params[:achievement_type_id].to_i
        end
        params[:achievement_type_id] = @campaign.achievement_types.first.id unless found
      else
        redirect_to entrance_campaign_achievements_path(Entrance::Campaign.find(12016))
      end
    else
      params[:achievement_type_id] ||= @campaign.achievement_types.first.id
    end

    params[:department] ||= Department.faculties.first.id

    achievement_type = Entrance::AchievementType.find(params[:achievement_type_id])
    if achievement_type.id == 56
      params[:department] = nil
    end

    @achievements = achievement_type.achievements.find_all {|a| a.entrant && a.entrant.packed_application }
                      .sort_by {|a| a.entrant.full_name}

    if params[:department]
      @achievements = @achievements.find_all {|a| a.entrant.packed_application.faculty == params[:department].to_i}
    end
  end
  
  def update
    @achievement.update(resource_params)
    respond_to do |format|
      format.js      
    end
  end

  def protocol
    respond_to do |format|
      format.pdf
    end
  end
  
  def ajax_update
    @achievement.update_attribute(:score, params[:score])
    render(json: { id: @achievement.id, score: @achievement.score })
  end

  def resource_params
    params.fetch(:entrance_achievement, {}).permit(
      :id, :entrant_id, :entrance_achievement_type_id, :score,
      :created_at, :updated_at
    )
  end
  
end  
