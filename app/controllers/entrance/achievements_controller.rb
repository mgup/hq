class Entrance::AchievementsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource through: :campaign, class: 'Entrance::Achievement'
  
  def index
    if params[:achievement_type_id]
      found = false
      @campaign.achievement_types.each do |achievement_type|
        found = true if achievement_type.id == params[:achievement_type_id].to_i
      end
      params[:achievement_type_id] = @campaign.achievement_types.first.id unless found
    else
      params[:achievement_type_id] ||= @campaign.achievement_types.first.id
    end
    
    achievement_type = Entrance::AchievementType.find(params[:achievement_type_id])
    
    @achievements = achievement_type.achievements.joins(:entrant).order('entrance_entrants.last_name', 'entrance_entrants.first_name', 'entrance_entrants.patronym')
  end
  
  def update
    @achievement.update(resource_params)
    respond_to do |format|
      format.js      
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