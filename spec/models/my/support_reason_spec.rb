require 'spec_helper'

describe My::SupportReason do
  describe 'обладает связями с другими моделями:' do
    it 'с поддержкой дополнений' do
      should have_many(:causereasons)
    end
    
    it 'с причинами' do
      should have_many(:causes)
    end
  end
end

