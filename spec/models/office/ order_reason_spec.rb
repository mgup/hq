require 'spec_helper'

describe Office::OrderReason do
  it 'должен обладать валидной фабрикой' do
    build(:position).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с приказом' do
      should belong_to(:order)
    end

    it 'с основанием для приказа' do
      should belong_to(:reason)
    end
  end
end
