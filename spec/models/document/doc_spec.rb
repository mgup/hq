require 'spec_helper'

describe Document::Doc do
  it 'должен обладать валидной фабрикой' do
    build(:doc).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'со студентами' do
      should have_many(:students)
    end

    it 'с документами студентов' do
      should have_many(:document_students)
    end

    it 'с изменениями' do
      should have_many(:metas)
    end
  end

end