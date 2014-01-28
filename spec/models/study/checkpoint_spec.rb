require 'spec_helper'

describe Study::Checkpoint do
  it 'должен обладать валидной фабрикой' do
    build(:checkpoint).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с дисциплиной' do
      should belong_to(:discipline)
    end
    it 'с оценками' do
      should have_many(:marks)
    end
  end

end