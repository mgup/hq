require 'rails_helper'

describe Study::Discipline do
  it 'должен обладать валидной фабрикой (через финальный экзамен)' do
    expect(build(:discipline)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с группой' do
      expect belong_to(:group)
    end

    it 'с ведущим преподавателем' do
      expect belong_to(:lead_teacher)
    end

    it 'с таблицей, обеспечивающей связь с дополнительными преподавателями' do
      expect have_many(:discipline_teachers)
    end

    it 'с дополнительными преподавателями' do
      expect have_many(:assistant_teachers).through(:discipline_teachers)
    end

    it 'с лекциями' do
      expect have_many(:lectures)
    end

    it 'с практическими или лабораторными занятиями' do
      expect have_many(:seminars)
    end

    it 'с контрольными точками' do
      expect have_many(:checkpoints)
    end

    it 'со всеми своими занятиями' do
      expect have_many(:classes)
    end

    it 'со всеми семестровыми формами контроля' do
      expect have_many(:exams)
    end

    it 'с зачётом, диф. зачётом или экзаменом' do
      expect have_one(:final_exam)
    end
  end

  describe 'обладает ограничениями на поля:' do
    it 'обязательное присутствие названия' do
      expect validate_presence_of(:name)
    end

    it 'обязательное присутствие года' do
      expect validate_presence_of(:year)
    end

    it 'год должен быть целым числом больше 2010 и меньше 2020' do
      expect validate_numericality_of(:year).is_greater_than(2010).is_less_than(2020)
    end

    it 'обязательное присутствие семестра' do
      expect validate_presence_of(:semester)
    end

    it 'семестр должен быть либо первым, либо вторым' do
      expect ensure_inclusion_of(:semester).in_array([1,2])
    end

    it 'обязательное присутствие группы' do
      expect validate_presence_of(:group)
    end

    it 'обязательное присутствие ведущего преподавателя' do
      expect validate_presence_of(:lead_teacher)
    end
  end
end