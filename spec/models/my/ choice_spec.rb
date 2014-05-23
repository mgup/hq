require 'spec_helper'

describe My::Choice do
  it 'должен обладать валидной фабрикой' do
    build(:choice).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с таблицей, обеспечивающей связь со студентами' do
      should have_many(:selections).class_name('My::Select')
    end

    it 'со студентами' do
      should have_many(:students).through(:selections)
    end
  end
end
