require 'rails_helper'

describe AchievementPeriod do
  describe 'должен обладать' do
    it 'достижениями' do 
      expect have_many(:achievements)
    end
    
    it 'отчетами о достижениях' do
      expect have_many(:achievement_reports)
    end
  end
end
      
