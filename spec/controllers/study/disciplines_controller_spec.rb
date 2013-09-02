require 'spec_helper'

describe Study::DisciplinesController do

   context 'для разработчиков' do
     before :each do
       @user = FactoryGirl.create(:developer)
       sign_in @user
     end

     describe 'GET #index' do
       before :each do
         @discipline = FactoryGirl.create(:discipline,  subject_teacher: @user.id,
                                          group: FactoryGirl.create(:group))
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
         @discipline = FactoryGirl.create(:discipline,  subject_teacher: @user.id,
                                          group: FactoryGirl.create(:group))
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
           response.should render_template :new
         end
       end
     end

     describe 'PUT #update' do
       before :each do
         @discipline = FactoryGirl.create(:discipline, subject_teacher: @user.id,
                                          group: FactoryGirl.create(:group))
       end

       context 'в случае успешного изменения' do
         before :each do
           Study::Discipline.any_instance.should_receive(:update).and_return(true)
         end

         it 'должен находить правильную дисциплину' do
           put :update, id: @discipline, discipline: {}
           assigns(:discipline).should eq(@discipline)
         end

         it 'должен переходить на представление с занятиями' do
           put :update, id: @discipline, discipline: {}
           response.should redirect_to study_discipline_checkpoints_path(@discipline)
         end
       end

       #context 'в случае неудачи' do
       #  before :each do
       #    Study::Discipline.any_instance.should_receive(:update).and_return(false)
       #  end
       #   context 'если идёт редактирование контрольных точек' do
       #      it 'должен перенаправлять на редактирование контрольных точек' do
       #        put :update, id: @discipline, discipline: {}
       #        ? Идёт редактирование контрольных точек?
       #        response.should render_template: 'study/checkpoints/new'
       #      end
       #    end
       #   context 'если не идёт редактирование контрольных точек' do
       #      it 'должен перенаправлять на редактирование дисциплины' do
       #        put :update, id: @discipline, discipline: {}
       #        response.should assert_template :edit
       #      end
       #    end
       #end
     end

     describe 'DELETE #destroy' do
       before :each do
         @discipline = FactoryGirl.create(:discipline, subject_teacher: @user.id,
                                          group: FactoryGirl.create(:group))
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