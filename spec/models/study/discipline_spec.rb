require 'spec_helper'

describe Study::Discipline do
  it 'должен обладать валидной фабрикой (через финальный экзамен)' do
    build(:discipline).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с группой' do
      should belong_to(:group)
    end
    it 'с ведущим преподавателем' do
      should belong_to(:lead_teacher)
    end
    it 'с таблицей, обеспечивающей связь с дополнительными преподавателями' do
      should have_many(:discipline_teachers)
    end
    it 'с дополнительными преподавателями' do
      should have_many(:assistant_teachers).through(:discipline_teachers)
    end
    it 'с лекциями' do
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
    it 'с зачётом, диф. зачётом или экзаменом' do
      should have_one(:final_exam)
    end
  end

  describe 'обладает ограничениями на поля:' do
    it 'обязательное присутствие названия' do
      should validate_presence_of(:name)
    end

    it 'обязательное присутствие года' do
      should validate_presence_of(:year)
    end
    it 'год должен быть целым числом больше 2010 и меньше 2020' do
      should validate_numericality_of(:year).is_greater_than(2010).is_less_than(2020)
    end

    it 'обязательное присутствие семестра' do
      should validate_presence_of(:semester)
    end
    it 'семестр должен быть либо первым, либо вторым' do
      should ensure_inclusion_of(:semester).in_array([1,2])
    end

    it 'обязательное присутствие группы' do
      should validate_presence_of(:group)
    end

    it 'обязательное присутствие ведущего преподавателя' do
      should validate_presence_of(:lead_teacher)
    end

  end
end