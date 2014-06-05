require 'spec_helper'

describe Document::DocumentStudent do
  describe 'обладает связями с другими моделями:' do
    it 'с документами' do
      expect belong_to(:document)
    end
    
    it 'со студентом' do
      expect belong_to(:student)
    end
  end
end
