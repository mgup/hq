require 'spec_helper'

describe My::SupportReason do
  describe 'обладает связями с другими моделями:' do
    it 'с поддержкой дополнений' do
      should belong_to(:causereasons)
    end
    
    it 'с причинами' do
      should belong_to(:causes)
    end
  end
end

