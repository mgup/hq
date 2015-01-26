require 'rails_helper'

describe Office::Reason do
  describe 'обладает связями с другими моделями' do
    it 'с шаблоном' do
      expect belong_to(:template)
    end

    it 'видов причин' do
      expect have_many(:order_reasons)
    end

    it 'видов' do
      expect have_many(:orders)
    end
  end
end

