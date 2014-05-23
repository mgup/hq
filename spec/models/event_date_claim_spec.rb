require 'spec_helper'
describe EventDateClaim do
  it 'должен обладать валидной фабрикой' do
    build(:event_date_claim).should be_valid
  end
  
  describe 'обладает связями с другими моделями:' do
    it 'с групой' do
      should belongs_to(:group)
    end
    
    it 'с событием' do
      should belongs_to(:event)
    end
  end
end
