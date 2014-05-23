require 'spec_helper'

describe Position do
  it 'должен обладать валидной фабрикой' do
    build(:acl_position).should be_valid
  end
  
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
