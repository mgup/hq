require 'rails_helper'

describe Curator::TaskType do
  describe 'обладает ограничениями на поля' do
    it 'обязательное поле присутствия названия' do	
      expect validate_presence_of(:name)
    end
  end
end
