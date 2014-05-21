require 'spec_helper'

describe Person do
  it 'должен обладать валидной фабрикой' do
    build(:student).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с фамилией' do
      should belong_to(:fname)
    end

    it 'с именем' do
      should belong_to(:iname)
    end

    it 'с отчеством' do
      should belong_to(:oname)
    end

    it 'с комнатой' do
      should belong_to(:room)
    end

    it 'с  студентами' do
      should have_many(:students)
    end
  end
end