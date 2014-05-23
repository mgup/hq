require 'spec_helper'

describe Position do
  it 'должен обладать валидной фабрикой' do
    build(:acl_position).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с событиями' do
      should belongs_to(:user)
    end
    
    it 'с ролью' do
      should belongs_to(:role)
    end
    
    it 'с отделом' do
      should belongs_to(:department)
    end
    
    it 'с назначением' do
      should belongs_to(:appointment)
    end
  end
end
