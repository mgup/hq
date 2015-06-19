require 'rails_helper'

describe Purchase::Good, type: :model do
  it 'должен быть валидной фабрикой' do
    expect(build(:purchase_good)).to be_valid
  end

  describe 'обладает связями с другими моделями' do
    it 'с товарными позициями' do
      expect have_many(:purchase_line_items)
    end
  end
end
