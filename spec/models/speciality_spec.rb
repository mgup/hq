require 'spec_helper'

describe Speciality do
  it 'должен обладать валидной фабрикой' do
    build(:speciality).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'со специальностью' do
      should belong_to(:faculty)
    end

    it 'с группами' do
      should have_many(:groups)
    end

    it 'с типами платежей' do
      should have_many(:payment_types)
    end
  end
end