require 'rails_helper'

describe My::SupportOption do
  describe 'обладает связями с другими моделями:' do
    it 'с поддержкой' do
      expect belong_to(:support)
    end
    
    it 'с причиной' do
      expect belong_to(:cause)
    end
  end
end

