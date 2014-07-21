require 'rails_helper'

describe AchievementReport do
  describe 'обладает связями с другими моделями' do
    it 'с выполненным периодом' do
      expect belong_to(:achievement_period)
    end

    it 'с пользователем' do
      expect belong_to(:user)
    end
  end
end

