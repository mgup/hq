require 'spec_helper'

describe ClaimsController do

     describe 'GET "index"' do
      before :each do
        @event = FactoryGirl.create(:event)
        get :index
      end

      it 'должен выполняться успешно' do
        response.should be_success
      end

      it 'должен выводить правильное представление' do
        response.should render_template(:index)
      end

      it 'в выводе должна присутствовать заявка' do
        assigns(:events).should include(@event)
      end
    end
  end

