require 'spec_helper'

describe UsersController do
  context 'для разработчиков' do
    before do
      @user = FactoryGirl.create(:developer)
      sign_in @user
    end

    describe 'GET "index"' do
      it 'должен выполняться успешно' do
        get :index
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        get :index
        response.should render_template(:index)
      end
    end

    describe 'GET "new"' do
      it 'должен выполняться успешно' do
        get :new
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        get :new
        response.should render_template(:new)
      end
    end

    describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          User.any_instance.should_receive(:save).and_return(true)
          post :create, user: {}
        end

        it 'должен создавать новую дисциплину' do
          flash[:notice].should_not be_nil
        end

        it 'должно происходить перенаправление на список дисциплин' do
          response.should redirect_to users_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          User.any_instance.should_receive(:save).and_return(false)
          post :create, user: {}
          assigns[:user].should be_new_record
          response.should render_template :new
        end
      end
    end

    describe 'GET "edit"' do
      before :each do
       @edited = FactoryGirl.create(:user)
       get :edit, id: @edited.id
      end
      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template :edit
      end

      it 'должен находить правильного пользователя' do
        assigns(:user).should eq(@edited)
      end
    end

    describe 'GET "show"' do
      before :each do
        @shown = FactoryGirl.create(:user)
        get :show, id: @shown.id
      end
      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:show)
      end

      it 'должен находить правильного пользователя' do
        assigns(:user).should eq(@shown)
      end
    end

    describe 'PUT #update' do
      before :each do
        @updated = FactoryGirl.create(:user)
      end
      context 'в случае успешного изменения' do
        before :each do
          User.any_instance.should_receive(:update).and_return(true)
          put :update, id: @updated
        end

        it 'должен находить правильного пользователя' do
          assigns(:user).should eq(@updated)
        end

        it 'должен переходить на представление с пользователями' do
          flash[:notice].should_not be_nil
          response.should redirect_to users_path
        end

      end

      #context 'в случае неудачи' do
      #  it 'должен перенаправлять на редактирование' do
      #    put :update, id: @updated, username: nil
      #    response.should render_template :edit
      #  end
      #end
    end

    describe 'GET "profile"' do
      before :each do
        get :profile, id: @user.id
      end
      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:profile)
      end

      it 'должен находить правильного пользователя' do
        assigns(:user).should eq(@user)
      end
    end
  end

  #context 'для пользователей, не являющихся разработчиками,' do
  #  it 'должен быть переход на главную страницу' do
  #    sign_in FactoryGirl.create(:user)
  #
  #    get :index
  #    response.should redirect_to(root_path)
  #  end
  #end

  context 'для не авторизованных пользователей' do
    it 'должен быть переход на страницу авторизации' do
      sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
    end
  end

end