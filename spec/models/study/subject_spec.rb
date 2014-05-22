require 'spec_helper'
describe Study::Subject do
  it 'должен обладать валидной фабрикой' do
    build(:study_subjects).should be_valid
  end
  describe 'обладает связями с другими моделями:' do
    it 'с групой' do
      should belong_to(:group)
    end
    it 'с пользователями' do
      should belong_to(:user)
    end
    it 'с оценками' do
      should have_many(:marks)
    end
  end
end
