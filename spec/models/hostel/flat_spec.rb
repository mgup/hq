require 'spec_helper'

describe Hostel::Flat do
  it 'должен обладать валидной фабрикой' do
    build(:flat).should be_valid
    #Либо на месте :flat ставишь Hostel
  end

  describe 'обладает связями с другими моделями:' do
    it 'с общежитием' do
      should belong_to(:hostel)
    end
    it 'с комнатами' do
      should have_many(:rooms)
    end

    it 'с жильцами' do
      should have_many(:residents)
    end
  end

end