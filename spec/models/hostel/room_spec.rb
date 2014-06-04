require 'spec_helper'

describe Hostel::Room do
  describe 'обладает связями с другими моделями:' do
    it 'с квартирой' do
      should belong_to(:flat).class_name('Hostel::Flat')
    end		

    it 'с проживающими' do
      should have_many(:residents).class_name('Person')
    end
  end
end
