require 'rails_helper'

describe Purchase::Purchase, type: :model do
  it 'должен быть валидной фабрикой' do
    expect(build(:purchase_purchase)).to be_valid
  end

  describe 'обладает связями с другими моделями' do
    it 'с товарными позициями' do
      expect have_many(:purchase_line_items)
    end

    it 'с товарами' do
      expect belong_to(:departments)
    end
  end
end
