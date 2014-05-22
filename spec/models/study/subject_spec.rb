require 'spec_helper'
describe Study::Subject do
  it 'должен обладать валидной фабрикой' do
    build(:study_subjects).should be_valid
  end
  describe 'обладает связями с другими моделями:' do
    it 'с дополнительными преподавателями' do
      should belong_to(:group)
    end
     it 'с пользователем' do
      should belongs_to(:user)
    end
    it 'с оценками' do
      should has_many(:marks)
    end
  end
end
