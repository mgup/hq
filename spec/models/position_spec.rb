require 'spec_helper'

describe Position do
  
  describe 'обладает связями с другими моделями:' do
    it 'с событиями' do
      should belong_to(:user)
    end
    
    it 'с ролью' do
      should belong_to(:role)
    end
    
    it 'с отделом' do
      should belong_to(:department)
    end
    
    it 'с назначением' do
      should belong_to(:appointment)
    end
  end
end
