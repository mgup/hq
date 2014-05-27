require 'spec_helper'

describe Curator::TaskUser do
  describe 'обладает связями с другими моделями:' do 	
    it 'с заданием' do
      should belong_to(:task)
    end		
    it 'с пользователем' do
      should belong_to(:user)
    end
  end	
end
