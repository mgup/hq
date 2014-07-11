require 'rails_helper'

describe Office::OrderStudent do
  describe 'обладает связями с другими моделями' do
    it 'с порядком' do
      expect belong_to(:order)
    end
    
    it 'со студентом' do
      expect belong_to(:student)
    end
  end
end

