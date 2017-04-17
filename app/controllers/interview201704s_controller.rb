class Interview201704sController < ApplicationController
  skip_before_filter :authenticate_user!
  load_and_authorize_resource except: [:index]

  layout 'static'

  before_action do
    @project_title = 'Использование информационных систем и программного
                      обеспечения, <small>апрель 2017</small>'.html_safe
  end

  def index
    redirect_to new_interview201704_path
  end

  def new
    @interview201704.ip_address = request.remote_ip
  end

  def create
    @interview201704.update_attributes(resource_params)
    if @interview201704.save
      redirect_to thank_you_interview201704s_path
    end
  end

  def thank_you
  end

  private

  def resource_params
    params.fetch(:interview201704, {}).permit(:department, :employee, 
                                              :ip_address,
                                              :question1, :question2,
                                              :question3, :question4,
                                              :question5, :question6,
                                              :question7, :question8)
  end
end
