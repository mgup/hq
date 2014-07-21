require 'rails_helper'

describe Study::Mark do
  it 'должен обладать валидной фабрикой' do
    expect(build(:mark)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'со студентом' do
      expect belong_to(:student)
    end

    it 'с занятием' do
      expect belong_to(:checkpoint)
    end
  end
end
