require 'spec_helper'

describe Document::Meta do
  describe 'обладает связями с другими моделями:' do
    it 'с документом' do
      should belong_to(:doc)
    end
  end
end

