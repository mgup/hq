module Entrance::CampaignHelper
  def campaign_stat(stats, payment, form)
    unless stats[payment][form][:total].zero?
      "#{stats[payment][form][:total]} (#{stats[payment][form][:original]})"
    end
  end
end