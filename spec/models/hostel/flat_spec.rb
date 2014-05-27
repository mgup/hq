require 'spec_helper'

describe Hostel::Flat do
  describe 'обладает связями с другими моделями:' do
    it 'общежитием' do
      should belong_to(:hostel)   
    end
    it 'человеком' do
      should belong_to(:person)   
    end
     it 'с комнатами' do
      should have_many(:rooms)
    end
     it 'с жителями' do
      should have_many(:achievements)
    end
  end
end

