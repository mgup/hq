require 'spec_helper'

describe Document::DocumentPerson do
  describe 'должен обладать связями с:' do
    it 'документами' do
      should belong_to(:document).class_name('Document::Doc')
    end

    it 'людьми' do
      should belong_to(:person)
    end
  end
end
