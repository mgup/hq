require 'rails_helper'

describe My::SupportCause do
  describe 'обладает связями с другими моделями:' do 
    it 'с поддержкой опций' do
      expect have_many(:support_options)
    end
    
    it 'с приведением причин' do
      expect have_many(:causereasons)
    end
    
    it 'с причинами' do
      expect have_many(:reasons)
    end
  end
end

