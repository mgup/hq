require 'spec_helper'

describe Study::DisciplinesController do

  context 'для разработчиков' do
    before :each do
      @user = FactoryGirl.create(:developer)
      sign_in @user
    end

    describe 'GET #index' do
      before :each do
        @discipline = FactoryGirl.create(:discipline)
        get :index
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

      it 'в выводе должна присутствовать тестовая дисциплина' do
        assigns(:disciplines).should include(@discipline)
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
        assigns(:discipline).new_record?.should be_true
      end
    end

    describe 'GET #edit' do
      before :each do
        @discipline = FactoryGirl.create(:discipline)
        get :edit, id: @discipline.id
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:edit)
      end

      it 'должен находить правильную запись' do
        assigns(:discipline).should == @discipline
      end
    end

    describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          Study::Discipline.any_instance.should_receive(:save).and_return(true)
          post :create, discipline: {}
        end

        it 'должен создавать новую дисциплину' do 
          flash[:notice].should_not be_nil
        end

        it 'должно происходить перенаправление на список дисциплин' do
          response.should redirect_to study_disciplines_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          Study::Discipline.any_instance.should_receive(:save).and_return(false)
          post :create, discipline: {}
          response.should render_action :new
        end
      end
    end

    describe 'PUT #update' do
      before :each do
        @discipline = FactoryGirl.create(:discipline)
      end

      context 'в случае успешного изменения' do
        before :each do
          Study::Discipline.any_instance.should_receive(:update_attributes).and_return(true)
        end

        it 'должен находить правильную дисциплину' do
          put :update, id: @discipline, subject: {}
          assigns(:discipline).should eq(@discipline)
        end

        it 'должен переходить на представление с занятиями' do
          put :update, id: @subject, subject: {}
          response.should render_template 'study/checkpoints/new'
        end
      end

      context 'в случае неудачи' do
        it 'должен перенаправлять на редактирование' do
          Study::Discipline.any_instance.should_receive(:update_attributes).and_return(false)
          put :update, id: @discipline, subject: {}
          response.should render_action :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @discipline = FactoryGirl.create(:discipline)
        Study::Discipline.any_instance.should_receive(:destroy).and_return(true)
        delete :destroy, id: @discipline
      end

      it 'должен находить правильную дисциплину' do
          assigns(:discipline).should eq(@discipline)
      end
      it 'должен перенаправлять на на список дисциплин' do
        response.should redirect_to study_disciplines_path
      end
    end
  end

end