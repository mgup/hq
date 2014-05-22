require 'spec_helper'

describe Study::Discipline do
  it 'должен обладать валидной фабрикой (через финальный экзамен)' do
    build(:discipline).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с группой' do
      should belong_to(:group)
    end
    it 'со студентом' do
      should belong_to(:lead_teacher)
    end
    it 'с таблицей, обеспечивающей связь с дополнительными преподавателями' do
      should have_many(:discipline_teachers)
    end
    it 'с преподавателями' do
      should have_many(:assistant_teachers).through(:discipline_teachers)
    end
    it 'с присутствием на лекции' do
      should have_many(:lectures)
    end
    it 'с практическими или лабораторными занятиями' do
      should have_many(:seminars)
    end
    it 'с контрольными точками' do
      should have_many(:checkpoints)
    end
    it 'со всеми своими занятиями' do
      should have_many(:classes)
    end
    it 'со всеми семестровыми формами контроля' do
      should have_many(:exams)
    end
   
  end
end
