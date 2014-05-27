require 'spec_helper'

describe Office::OrderStudent do
  describe 'обладает связями с другими моделями' do
    it 'с порядком' do
      should belong_to(:order)
    end
    
    it 'со студентом' do
      should belong_to(:student)
    end
  end
end

