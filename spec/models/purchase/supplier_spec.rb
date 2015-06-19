require 'rails_helper'

describe Purchase::Supplier, type: :model do
  it 'должен быть валидной фабрикой' do
    expect(build(:purchase_supplier)).to be_valid
  end

  describe 'обладает связями с другими моделями' do
    it 'с товарными позициями' do
      expect have_many(:purchase_line_item)
    end
  end
end
