require 'rails_helper'

describe Purchase::GoodsController, type: :controller do
  context 'для разработчиков' do
    before do
      @user = create(:user, :developer)
      sign_in @user
    end

    describe 'GET "index"' do
      before :each do
        @purchase_good = FactoryGirl.create(:purchase_good)
        get :index
      end

      it 'должен быть успешный' do
        expect(response).to be_success
      end

      it 'должна выводиться правильная страница' do
        expect(response).to render_template(:index)
      end

      it 'в выводе должна присутствовать тестовый товар' do
        expect(assigns(:goods)).to include(@purchase_good)
      end
    end

    describe 'get new' do
      before :each do
        get :new
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:new)
      end

      it 'должен содержать новую запись' do
        expect(assigns(:good).new_record?).to be_truthy
      end
    end

    describe 'GET "edit"' do
      before :each do
        @edited = FactoryGirl.create(:purchase_good)
        get :edit, id: @edited.id
      end

      it 'должен выполняться успешно' do
        expect(response).to be_success
      end

      it 'должен выводить правильное представление' do
        expect(response).to render_template(:edit)
      end

      it 'должен находить правильный товар' do
        expect(assigns(:good)).to eq(@edited)
      end
    end

    describe 'POST #create' do
      context 'в случае ошибки' do
        it 'должен перенаправить на создание' do
          allow(Purchase::Good).to receive(:save).and_return(false)

          post :create, purchase_good: {}
          expect(response).to render_template :new
        end
      end
    end

    describe 'PUT #update' do
      before :each do
        @updated = FactoryGirl.create(:purchase_good)
      end

      context 'в случае успешного изменения' do
        before :each do
          allow(Purchase::Good).to receive(:update).and_return(true)

          put :update, id: @updated, purchase_good: {}
        end

        it 'должен находить правильный товар' do
          expect(assigns(:good)).to eq(@updated)
        end

        it 'должен переходить на страницу с товарами' do
          expect(flash[:notice]).not_to be_nil
          expect(response).to redirect_to purchase_goods_path
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @deleted = FactoryGirl.create(:purchase_good)
        expect { delete :destroy, id: @deleted }
          .to change { Purchase::Good.count }.by(-1)
      end

      it 'должен находить правильный товар' do
        expect(assigns(:good)).to eq(@deleted)
      end
    end
  end
end
