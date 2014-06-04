require 'spec_helper'

describe My::SupportOption do
  describe 'обладает связями с другими моделями:' do
    it 'с поддержкой' do
      should belong_to(:support)
    end
    
    it 'с причиной' do
      should belong_to(:cause)
    end
  end
end

