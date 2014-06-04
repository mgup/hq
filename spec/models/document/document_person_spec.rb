require 'spec_helper'

describe Document::DocumentPerson do
  describe 'обладает связями с другими моделями:' do
    it 'с документами' do
      should belong_to(:document)   
    end

    it 'с человеком' do
      should belong_to(:person)   
    end
  end
end

