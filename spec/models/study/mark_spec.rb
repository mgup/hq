require 'spec_helper'

describe Study::Mark do
  it 'должен обладать валидной фабрикой' do
    build(:mark).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'со студентом' do
      should belong_to(:student)
    end

    it 'с занятием' do
      should belong_to(:checkpoint)
    end
  end
end
