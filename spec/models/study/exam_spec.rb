require 'spec_helper'

describe Study::Exam  do
  it 'должен обладать валидной фабрикой' do
    build(:exam).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с дисциплиной' do
      should belong_to(:discipline)
    end

     it 'с группой' do
      should belong_to(:group)
    end

    it 'со студентом' do
      should belong_to(:student)
    end

    it 'со студентами' do
      should have_many(:students)
    end

    it 'с оценками' do
      should have_many(:marks)
    end

    it 'с итоговыми оценками' do
      should have_many(:final_marks)
    end

    it 'с рейтинговыми оценками' do
      should have_many(:rating_marks)
    end

     it 'с пересдачами' do
      should have_many(:repeats)
    end

     it 'с колличеством пересдач' do
      should have_many(:mass_repeats)
    end

    it 'с paret_exam' do
      should belong_to(:paret_exam)
    end

  end

end