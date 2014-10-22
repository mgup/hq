require 'rails_helper'

describe Study::Subject do
  describe 'обладает связями с другими моделями:' do
    it 'с группой' do
      expect belong_to(:group)
    end

    it 'с пользователями' do
      expect belong_to(:user)
    end

    it 'с оценками' do
      expect have_many(:marks)
    end
  end
end
