require 'rails_helper'

describe Speciality do
  it 'должен обладать валидной фабрикой' do
    expect(build(:speciality)).to be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'со специальностью' do
      expect belong_to(:faculty)
    end

    it 'с группами' do
      expect have_many(:groups)
    end

    it 'с типами платежей' do
      expect have_many(:payment_types)
    end
  end
end