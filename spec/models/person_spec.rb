require 'spec_helper'

describe Person do
  it 'должен обладать валидной фабрикой' do
    build(:student).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с фамилией' do
      should  belongs_to(:fname)
    end
    
    it 'с именем' do
      should  belongs_to(:iname)
    end
    
    it 'с отчеством' do
      should  belongs_to(:oname)
    end
    
    it 'с комнатой' do
      should  belongs_to(:room)
    end
    
    it 'со студентами' do
      should has_many(:students)
    end
  end
end
