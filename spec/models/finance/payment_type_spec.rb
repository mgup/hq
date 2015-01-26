require 'rails_helper'

describe Finance::PaymentType do
  describe 'обладает связями с другими моделями:' do 
    it 'со специальностью' do
      expect belong_to(:speciality)
    end
    
    it 'с ценами' do
      expect have_many(:prices)
    end
  end
end
