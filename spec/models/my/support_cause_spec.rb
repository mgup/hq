require 'spec_helper'

describe My::SupportCause do
  describe 'обладает связями с другими моделями:' do 
    it 'с поддержкой опций' do
      should have_many(:support_options)
    end
    
    it 'с приведением причин' do
      should have_many(:causereasons)
    end
    
    it 'с причинами' do
      should have_many(:reasons)
    end
  end
end

