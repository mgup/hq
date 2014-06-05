require 'spec_helper'

describe ActivitiesController, type: :controller do
  before do
    @user = create(:user, :developer)
    sign_in @user
  end

	describe 'GET "index"' do
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

	describe 'GET #new' do
    before :each do
      get :new
    end

    it 'должен выполняться успешно' do
      expect(response).to be_success
    end

    it 'должен выводить правильное представление' do
      expect(response).to render_template(:new)
    end
  end
end
