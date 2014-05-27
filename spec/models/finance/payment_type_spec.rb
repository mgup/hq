require 'spec_helper'

describe Finance::PaymentType do

  describe 'обладает связями с другими моделями:' do
    it 'с ценой' do
      should have_many(:prices)
    end

    it 'с специальностью' do
      should belong_to(:speciality)
    end
    
  end
end

