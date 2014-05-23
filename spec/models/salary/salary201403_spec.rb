require 'spec_helper'

describe Salary::Salary201403 do
  it 'должен обладать валидной фабрикой' do
    build(:salary201403).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с пользователем' do
      should belong_to(:user)
    end
    it 'с департаментом' do
      should belong_to(:department)
    end
  end

end
