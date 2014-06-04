require 'spec_helper'

describe AchievementReport do
  describe 'обладает связями с другими моделями' do
    it 'с выполненным периодом' do
      should belong_to(:achievement_period)
    end

    it 'с пользователем' do
      should belong_to(:user)
    end
  end
end

