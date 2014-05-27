require 'spec_helper'

describe Document::Doc do
  describe 'обладает связями с другими моделями:' do
    it 'с документами студентов' do
      should have_many(:document_students)
    end
    
    it 'сo студентами' do
      should have_many(:students)
    end
    
    it 'с закладками' do
      should have_many(:metas)
    end
  end
end
