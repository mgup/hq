require 'spec_helper'

describe Study::DisciplineTeacher do
  it 'должен обладать валидной фабрикой' do
    build(:subject_teacher).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с ассистентом (аспирантом)' do
      should belong_to(:assistant_teacher)
    end
    it 'с дисциплиной' do
      should have_many(:discipline)
    end
  end

end