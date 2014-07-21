require 'rails_helper'

describe Document::Meta do
  describe 'обладает связями с другими моделями:' do
    it 'с документом' do
      expect belong_to(:doc)
    end
  end
end

