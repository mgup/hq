require 'rails_helper'

describe Curator::TaskUser do
  describe 'обладает связями с другими моделями:' do 	
    it 'с заданием' do
      expect belong_to(:task)
    end	
    
    it 'с пользователем' do
      expect belong_to(:user)
    end
  end	
end
