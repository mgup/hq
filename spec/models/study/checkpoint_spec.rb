require 'rails_helper'

describe Study::Checkpoint do
  it 'должен обладать валидной фабрикой' do
    expect(build(:checkpoint)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с дисциплиной' do
      expect belong_to(:discipline)
    end
    it 'с оценками' do
      expect have_many(:marks)
    end
  end

end