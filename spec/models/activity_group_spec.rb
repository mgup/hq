require 'rails_helper'

describe ActivityGroup do
  describe 'обладает связями' do
    it 'с активностью' do
      expect have_many(:activities)
    end
    
    it 'обязательно присутствие названия' do
      expect validate_presence_of(:name)
    end
  end
  
end
