require 'spec_helper'

describe Hostel::Host do
  describe 'обладает связями с другими моделями:' do
    it 'с квартирами' do
      should have_many(:flats)
    end
  end
end

