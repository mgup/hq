require 'rails_helper'

describe Study::Exam  do
  it 'должен обладать валидной фабрикой' do
    expect(build(:exam)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с дисциплиной' do
      expect belong_to(:discipline)
    end

     it 'с группой' do
      expect belong_to(:group)
    end

    it 'со студентом' do
      expect belong_to(:student)
    end

    it 'со студентами' do
      expect have_many(:students)
    end

    it 'с оценками' do
      expect have_many(:marks)
    end

    it 'с итоговыми оценками' do
      expect have_many(:final_marks)
    end

    it 'с рейтинговыми оценками' do
      expect have_many(:rating_marks)
    end

     it 'с пересдачами' do
      expect have_many(:repeats)
    end

     it 'с колличеством пересдач' do
      expect have_many(:mass_repeats)
    end

    it 'с paret_exam' do
      expect belong_to(:paret_exam)
    end
  end
end
