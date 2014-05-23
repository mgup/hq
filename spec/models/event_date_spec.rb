require 'spec_helper'
describe EventDate do
  it 'должен обладать валидной фабрикой' do
    build(:event_date).should be_valid
  end
  
  describe 'обладает связями с другими моделями:' do
    it 'с событием' do
      should belongs_to(:event)
    end
    
    it 'с датой событий посетителя' do
      should has_many(:visitor_event_dates)
    end
    
    it 'с пользователями' do
      should has_many(:users)
    end
    
    it 'со студентами' do
      should has_many(:students)
    end
  end
end
