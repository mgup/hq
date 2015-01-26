require 'rails_helper'

describe My::SupportReason do
  describe 'обладает связями с другими моделями:' do
    it 'с поддержкой дополнений' do
      expect have_many(:causereasons)
    end
    
    it 'с причинами' do
      expect have_many(:causes)
    end
  end
end

