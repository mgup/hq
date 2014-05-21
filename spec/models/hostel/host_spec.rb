require 'spec_helper'

describe Hostel::Host  do
  it 'должен обладать валидной фабрикой' do
    build(:hostel).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с квартирой' do
      should belong_to(:flats)
    end
  end

end