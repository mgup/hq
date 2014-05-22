require 'spec_helper'
describe EventCategory do
  it 'должен обладать валидной фабрикой' do
    build(:event_category).should be_valid
  end
  describe 'обладает связями с другими моделями:' do
    it 'с событиями' do
      should has_many(:events)
    end
  end
end
