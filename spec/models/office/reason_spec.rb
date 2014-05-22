require 'spec_helper'

describe Office::Reason do
	it 'должен обладать валидной фабрикой' do
		build(template_reason).should be_valid
	end

	describe 'обладает связями с другими моделями' do
		it 'с шаблоном' do
			should belong_to(:template)
		end
  end
  describe 'имеет много' do
		it 'видов причин' do
			should has_many(:order_reasons)
		end

		it 'видов' do
			should has_many(:orders)
		end

	end
end
