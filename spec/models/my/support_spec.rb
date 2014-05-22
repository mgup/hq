require 'spec_helper'

describe My::Support do
  it 'должен обладать валидной фабрикой' do
    build(:support).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с опциями' do
      should have_many(:options)
    end
    it 'с делом' do
      should have_many(:causes).through(:options)
    end
    it 'со студентами' do
      should belong_to(:student)
    end
  end

end