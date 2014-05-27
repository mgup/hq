require 'spec_helper'

describe Document::DocumentPerson do
  describe 'обладает связями с другими моделями:' do
    it 'с документом' do
      should belong_to(:document)
    end
    
    it 'с субъектом' do
      should belong_to(:person)
    end
  end
end
