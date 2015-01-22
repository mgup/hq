require 'rails_helper'

describe Office::Cause do
  describe 'обладает связями с другими моделями:' do
    it 'с шаблонами' do
      expect belong_to(:template)
    end
  end
end

