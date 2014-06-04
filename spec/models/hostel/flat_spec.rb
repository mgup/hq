require 'spec_helper'

describe Hostel::Flat do
  describe 'обладает связями с другими моделями:' do
    it 'с общежитием' do
      should belong_to(:hostel).class_name('Hostel::Host')
    end
    
    it 'с комнатами' do
      should have_many(:rooms).class_name('Hostel::Room')
    end
    
    it 'с проживающими' do
      should have_many(:residents).class_name('Person')
    end
  end
end
