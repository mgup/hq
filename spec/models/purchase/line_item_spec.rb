require 'rails_helper'

describe Purchase::LineItem, type: :model do
  it 'должен быть валидной фабрикой' do
    expect(build(:purchase_line_item)).to be_valid
  end

  describe 'обладает связями с другими моделями' do
    it 'с товарами' do
      expect belong_to(:purchase_goods)
    end

    it 'с поставщиками' do
      expect belong_to(:purchase_suppliers)
    end

    it 'с заявками' do
      expect belong_to(:purchase_purchases)
    end
  end
end
