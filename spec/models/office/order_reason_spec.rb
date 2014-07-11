require 'rails_helper'

describe Office::OrderReason do
  describe 'обладает связями с другими моделями' do
    it 'с порядком' do
      expect belong_to(:order)
    end
    
    it 'с причиной' do
      expect belong_to(:reason)
    end
  end
end

