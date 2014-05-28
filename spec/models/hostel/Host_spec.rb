require 'spec_helper'

describe Hostel::Host do
  describe 'должно обладать' do 	
    it 'квартирами' do
      should have_many(:flats).class_name('Hostel::Flat')
    end
  end
end
