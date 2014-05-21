require 'spec_helper'

describe Study::DisciplineTeacher do
  it 'должен обладать валидной фабрикой (через финальный экзамен)' do
    build(:discipline).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с ассистентом преподавателя' do
      should belong_to(:assistant_teacher)
    end
    it 'с дисциплиной' do
      should belong_to(:discipline)
    end

  end
end