require 'spec_helper'

describe Study::Xmark do
  describe 'обладает связями с другими моделями:' do
    it 'с дисциплиной' do
      should belong_to(:subject)
    end
    it 'с пользователь' do
      should belong_to(:user)
    end
     it 'со студентом' do
      should belong_to(:student)
    end
  end
end

