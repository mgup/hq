require 'spec_helper'

describe My::SupportCauseReason do
  describe 'обладает связями с другими моделями:' do
    it 'с причиной' do
      should belong_to(:cause)
    end
    
    it 'с причиной' do
      should belong_to(:reason)
    end
  end
end

