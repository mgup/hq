require 'spec_helper'

describe Office::Order do
  it 'должен обладать валидной фабрикой' do
    build(:order).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с опциями' do
      should belongs_to(:template)
    end
    it 'с делом' do
      should have_many(:students_in_order)
    end
    it 'со студентами' do
      should have_many(:order_reasons)
    end
        it 'со студентами' do
      should have_many(:students)
    end
        it 'со студентами' do
      should have_many(:reasons)
    end
  end

end