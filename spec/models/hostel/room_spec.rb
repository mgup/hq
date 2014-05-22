require 'spec_helper'

describe Hostel::Room do
  it 'должен обладать валидной фабрикой' do
    build(:room).should be_valid
    #Либо на месте :room ставить Hostel
  end

  describe 'обладает связями с другими моделями:' do
    it 'со квартирами' do
      should belong_to(:flat)
    end

    it 'с жильцами' do
      should have_many(:residents)
    end
  end
end