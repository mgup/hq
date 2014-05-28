require 'spec_helper'

describe Document::DocumentPerson do
  it 'должен обладать валидной фабрикой' do
    build(:document_student).should be_valid
  end

  describe 'должен обладать связями с:' do
    it 'документами' do
      should belong_to(:document).class_name('Document::Doc')
    end

    it 'людьми' do
      should belong_to(:person)
    end
  end
end
