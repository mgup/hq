require 'rails_helper'

describe Hostel::Host do
  describe 'обладает связями с другими моделями:' do
    it 'с квартирами' do
      expect have_many(:flats).class_name('Hostel::Flat')
    end
  end
end
