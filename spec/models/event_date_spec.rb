require 'rails_helper'

describe EventDate do
  describe 'обладает связями с другими моделями' do
    it 'с событием' do
      expect belong_to(:event)
    end
    
    it 'пользователей' do
      expect have_many(:users)
    end
    
    it 'студентов' do
      expect have_many(:students)
    end
  end
end

