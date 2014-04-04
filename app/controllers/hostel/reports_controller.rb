class Hostel::ReportsController < ApplicationController
  load_and_authorize_resource

  def index
    @reports = @reports.from_curator(current_user)
  end

  def new
  end

  def create
    #raise resource_params.inspect
    @report = Hostel::Report.new(resource_params)
    if @report.save
      redirect_to hostel_reports_path, notice: 'Запись успешно создана.'
    else
      @hostel = Hostel::Host.find(params[:hostel]) if params[:hostel] != ''
      render action: :new
    end
  end

  def edit
    @hostel = @report.flat.hostel
  end

  def print
    respond_to do |format|
      format.pdf
    end
  end

  def update
    if @report.update(resource_params)
      redirect_to hostel_reports_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy
    @report.destroy
    redirect_to hostel_reports_path
  end

  def resource_params
    params.fetch(:hostel_report, {}).permit(:user_id, :flat_id, :date, :time,
                report_offenses_attributes: [:id, :hostel_offense_id, :_destroy,
                offense_rooms_attributes: [:id, :room_id, :_destroy],
                offense_students_attributes: [:id, :student_id, :_destroy]])
  end
end