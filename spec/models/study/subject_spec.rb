require 'spec_helper'

describe Study::Subject do
  
  describe 'обладает связями с другими моделями:' do
    it 'с группой' do
      should belong_to(:group)
    end
        it 'с пользователями' do
      should belong_to(:user)
    end
    it 'с оценками' do
      should have_many(:marks)
    end
  end

end