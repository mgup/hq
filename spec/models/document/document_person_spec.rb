require 'spec_helper'

describe Document::DocumentPerson do
  describe 'обладает связями с другими моделями:' do
    it 'документами' do
      should belong_to(:document)   
    end

    it 'человеком' do
      should belong_to(:person)   
    end
  end
end

