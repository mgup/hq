require 'spec_helper'

describe ClaimsController do

   describe 'POST #create' do
      context 'в случае успешного создания' do
        before :each do
          EventDateClaim.any_instance.should_receive(:save).and_return(true)
          post :create, event: {}
        end

        it 'должен создавать новую заявку' do
          flash[:notice].should_not be_nil
        end

        it 'должно происходить перенаправление на страницу со структурой университета' do
          response.should redirect_to actual_events_path
        end
      end

      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          EventDateClaim.any_instance.should_receive(:save).and_return(false)
          post :create, event: {}
          response.should render_template :new
        end
      end
    end
  end
