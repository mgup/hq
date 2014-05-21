require 'spec_helper'
describe LearnController do
context 'Когда пользователь не найден' do
   it "Ввести еще раз" 
sign_out :user

      get :index
      response.should redirect_to(new_user_session_path)
end
context 'Пользователь найден' do
  it "Продолжить работу"
   @student = create(:student)
        get :index
end
