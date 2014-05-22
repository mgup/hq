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
	
	describe 'GET #new' do
      before :each do
        get :new
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:new)
      end
    end
    
    describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          Activity.any_instance.should_receive(:save).and_return(true)
          post :create, activity: {}
        end

        # it 'должен создавать новый Activity' do
        #   flash[:notice].should_not be_nil
        # end

        it 'должно происходить перенаправление на страницу со структурой Activity' do
          response.should redirect_to activities_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          Activity.any_instance.should_receive(:save).and_return(false)
          post :create, activity: {}
          
          response.should render_template :new
        end
      end
    end
end
