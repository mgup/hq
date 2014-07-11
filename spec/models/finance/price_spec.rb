require 'rails_helper'

describe Finance::Price do
  describe 'обладает связями с другими моделями:' do 
    it 'с типом оплаты' do
      expect belong_to(:type)
    end
  end
end
