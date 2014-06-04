require 'spec_helper'

describe Document::DocumentPerson do
  describe 'должен обладать связями с другими моделями:' do
    it 'с документами' do
      should belong_to(:document).class_name('Document::Doc')
    end

    it 'с человеком' do
      should belong_to(:person)
    end
  end
end
