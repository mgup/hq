require 'spec_helper'

describe Finance::PaymentType do
  describe 'обладает связями с другими моделями:' do 
    it 'со специальностью' do
      should belong_to(:speciality)
    end
    it 'с ценами' do
      should have_many(:prices)
    end
  end
end
