require 'spec_helper'

describe Curator::TaskType do
  describe 'обладает ограничениями на поля' do
    it 'обязательное поле присутствия названия' do	
      should validate_presence_of(:name)
    end
  end
end
