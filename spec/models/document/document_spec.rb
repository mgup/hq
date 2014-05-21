require 'spec_helper'

describe Document::Doc do
  it 'должен обладать валидной фабрикой' do
    build(:document).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с документами студентов' do
      should has_many (:document_students)
    end
    it 'сo студентами' do
      should have_many(:students)
    end

    it 'с метаданными' do
      should have_many(:metas)
    end
  end

end