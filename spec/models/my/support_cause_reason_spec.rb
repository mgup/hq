require 'rails_helper'

describe My::SupportCauseReason do
  describe 'обладает связями с другими моделями:' do
    it 'с причиной' do
      expect belong_to(:cause)
    end
    
    it 'с причиной' do
      expect belong_to(:reason)
    end
  end
end

