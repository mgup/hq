require 'spec_helper'

describe Finance::Payment do
  it 'должен обладать валидной фабрикой' do
    build(:finance_payment).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с видом платежа' do
      should belong_to(:payment_type)
    end
    it 'со студентами' do
      should belong_to(:student)
    end
  end

end