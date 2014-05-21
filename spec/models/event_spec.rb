require 'spec_helper'

describe Event do
  it 'должен обладать валидной фабрикой' do
    build(:event).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с категорией' do
      should belong_to(:category)
    end

    it 'с датой' do
      should have_many(:dates)
    end

    it 'с заявками' do
      should have_many(:claims)
    end

    it 'с сотрудниками' do
      should have_many(:users).through(:dates)
    end
  end
 
end