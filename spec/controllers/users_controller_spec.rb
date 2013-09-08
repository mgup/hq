require 'spec_helper'

describe UsersController do
  context 'неавторизованный пользователь' do
    it 'должен перенаправляться на страницу авторизации' do
      sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
    end
  end

  context 'авторизованный пользователь без прав администратора' do

  end

  context 'авторизованный администратор' do
    before :each do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'при запросе списка пользователей' do
      it 'должен получить ответ' do
        get :index
        should respond_with(:success)
      end

      it 'должен видеть страницу со списком пользователей' do
        get :index
        should render_template(:index)
      end

      it 'должен получить список пользователей' do
        another_user = create(:user)

        get :index
        assigns(:users).should include(@user)
        assigns(:users).should include(another_user)
      end
    end

    describe 'при создании пользователя' do
      before :each do
        get :new
      end

      it 'должен получить ответ' do
        should respond_with(:success)
      end

      it 'должен видеть страницу создания пользователя' do
        should render_template(:new)
      end

      it 'должен получить заготовку для пользователя' do
        assigns(:user).should be_a_new(User)
      end
    end

    describe 'при сохранении нового пользователя' do

    end

    describe 'при редактировании пользователя' do
      before :each do
        @u = create(:user)
        get :edit, id: @u.id
      end

      it 'должен получить ответ' do
        should respond_with(:success)
      end

      it 'должен видеть страницу редактирования пользователя' do
        should render_template(:edit)
      end

      it 'должен получить нужного пользователя' do
        assigns(:user).should eql(@u)
      end
    end

    describe 'при сохранении изменений о пользователе' do

    end

    describe 'при удалении пользователя' do

    end
  end

  #  describe 'POST #create' do
  #    context 'в случае успешного создания' do
  #      before :each do
  #        User.any_instance.should_receive(:save).and_return(true)
  #        post :create, user: {}
  #      end
  #
  #      it 'должен создавать новую дисциплину' do
  #        flash[:notice].should_not be_nil
  #      end
  #
  #      it 'должно происходить перенаправление на список дисциплин' do
  #        response.should redirect_to users_path
  #      end
  #    end
  #
  #    context 'в случае ошибки' do
  #      it 'должен перенаправить на создание' do
  #        User.any_instance.should_receive(:save).and_return(false)
  #        post :create, user: {}
  #        assigns[:user].should be_new_record
  #        response.should render_template :new
  #      end
  #    end
  #  end
  #
  #  describe 'GET "show"' do
  #    before :each do
  #      @shown = FactoryGirl.create(:user)
  #      get :show, id: @shown.id
  #    end
  #    it 'должен выполняться успешно' do
  #      response.should be_success
  #    end
  #
  #    it 'должен выводить правильное представление' do
  #      response.should render_template(:show)
  #    end
  #
  #    it 'должен находить правильного пользователя' do
  #      assigns(:user).should eq(@shown)
  #    end
  #  end
  #
  #  describe 'PUT #update' do
  #    before :each do
  #      @updated = FactoryGirl.create(:user)
  #    end
  #    context 'в случае успешного изменения' do
  #      before :each do
  #        User.any_instance.should_receive(:update).and_return(true)
  #        put :update, id: @updated
  #      end
  #
  #      it 'должен находить правильного пользователя' do
  #        assigns(:user).should eq(@updated)
  #      end
  #
  #      it 'должен переходить на представление с пользователями' do
  #        flash[:notice].should_not be_nil
  #        response.should redirect_to users_path
  #      end
  #
  #    end
  #
  #    #context 'в случае неудачи' do
  #    #  it 'должен перенаправлять на редактирование' do
  #    #    put :update, id: @updated, username: nil
  #    #    response.should render_template :edit
  #    #  end
  #    #end
  #  end
  #
  #  describe 'GET "profile"' do
  #    before :each do
  #      get :profile, id: @user.id
  #    end
  #    it 'должен выполняться успешно' do
  #      response.should be_success
  #    end
  #
  #    it 'должен выводить правильное представление' do
  #      response.should render_template(:profile)
  #    end
  #
  #    it 'должен находить правильного пользователя' do
  #      assigns(:user).should eq(@user)
  #    end
  #  end
  #end
  #
  ##context 'для пользователей, не являющихся разработчиками,' do
  ##  it 'должен быть переход на главную страницу' do
  ##    sign_in FactoryGirl.create(:user)
  ##
  ##    get :index
  ##    response.should redirect_to(root_path)
  ##  end
  ##end
  #
end