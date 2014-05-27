require 'spec_helper'

describe Hostel::OffensesController do
  context 'для разработчиков' do
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
      
      it 'должен содержать новую запись' do
        assigns(:offenses).new_record?.should be_true
      end
    end
 describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          post :create, offense: {  name "MyString"
    						type 1
   							 penalty "MyString"
   							  Hostel::Offense.any_instance.should_receive(:save).and_return(true)
        end
        
        it 'должен создавать новое нарушение' do
          flash[:notice].should_not be_nil
        end
    
        it 'должно происходить перенаправление на страницу с нарушениями' do
          response.should redirect_to hostel_offenses_path
        end
      end
    
      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          post :create, speciality: {}
          Hostel::Offense.any_instance.should_receive(:save).and_return(false)
          response.should render_template :new
        end    
    end
end


