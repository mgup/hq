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
  
end  