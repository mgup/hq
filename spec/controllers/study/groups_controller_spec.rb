require 'rails_helper'

describe Study::GroupsController, type: :controller do
  before  do
    @group = FactoryGirl.create(:group)
  end

  describe 'GET #index' do
    before :each do
      get :index
    end

    it 'должен выполняться успешно' do
      expect(response).to be_success
    end

    it 'должен выводить правильное представление' do
      expect(response).to render_template(:index)
    end
  end
end
