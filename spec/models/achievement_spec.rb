require 'rails_helper'

describe Achievement do
  describe 'обладает связями с другими моделями:' do
    it 'с периодом' do
      expect belong_to(:period)
    end
    
    it 'с человеком' do
      expect belong_to(:user)
    end
    
    it 'с деятельностью' do
      expect belong_to(:activity)
    end
  end
end
