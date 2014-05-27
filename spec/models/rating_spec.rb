require 'spec_helper'

describe Rating do
  describe 'обладает связями с другими моделями:' do
    it 'с пользователем' do
      should belong_to(:user)
    end
  end
end