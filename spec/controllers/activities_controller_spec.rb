require 'spec_helper'

describe ActivitiesController do 
before do
  @user = create(:user, :developer)
  sign_in @user
end

  describe 'GET "index"' do
    before :each do
      get :index
    end
    it 'должен выполняться успешно' do
      response.should be_success
    end

    it 'должен выводить правильное представление' do
      response.should render_template(:index)
    end

  end


end