require 'rails_helper'

describe Hostel::Room do
  describe 'обладает связями с другими моделями:' do
    it 'с квартирой' do
      expect belong_to(:flat).class_name('Hostel::Flat')
    end		

    it 'с проживающими' do
      expect have_many(:residents).class_name('Person')
    end
  end
end
