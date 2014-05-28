
require 'spec_helper'

describe Test_Mark do
  it 'должен обладать валидной фабрикой' do
    build(:mark).should be_valid
  end
  describe 'обладает связями с другими моделями:' do
    it 'со студентом' do
      should belong_to(:student)
    end
    it 'с экзаменом' do
      should belong_to(:exam)
    end
  end
end