require 'rails_helper'

describe Office::OrderXsl do
  describe 'обладает связями с другими моделями' do
    it 'с порядком шаблона' do
      expect belong_to(:order_template)
    end
  end
end

