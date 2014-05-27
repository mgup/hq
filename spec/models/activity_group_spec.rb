require 'spec_helper'

describe ActivityGroup do
  describe 'обладает ограничениями на поля' do
    it 'обязательно присутствие названия' do
      should validate_presense_of(:name)
    end
  end
  
  describe 'обладает связями' do
    it 'с активностью' do
      should have_many(:activities)
    end
  end
  
end
