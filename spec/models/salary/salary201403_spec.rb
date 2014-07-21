require 'rails_helper'

describe Salary::Salary201403 do
  describe 'обладает связями с другими моделями:' do
    it 'с пользователем' do
      expect belong_to(:user)
    end
    
    it 'с департаментом' do
      expect belong_to(:department)
    end
  end
end

