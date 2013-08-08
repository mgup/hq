#encoding utf-8
class My::SupportsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_student

  def index ; end

  def new 
  end

  def create
    @support = My::Support.new student: @student, year: params[:year],
                               month: params[:month], series: params[:series],
                               number: params[:number], date: params[:date],
                               department: params[:department], birthday: params[:birthday],
                               address: params[:address], phone: params[:phone]
    if @support.save
      params[:causes].each do |cause|
        option = My::SupportOptions.new support: @support, cause: My::SupportCause.find(cause)
        option.save
      end
      redirect_to "/my/student/#{@student.id}/download_pdf", notice: 'Успешно создано'
    else
       redirect_to new_my_student_support_path(@student), notice: 'Произошла ошибка'
    end
  end

def download_pdf
      @student = Student.find(params[:student_id])
      @pdf = generate_pdf(@student.supports.last)
      send_data(@pdf, :filename => "support.pdf", :type => "application/pdf")
  end

  private 
  def generate_pdf(support)
    student = Student.find(support.support_student)
    Prawn::Document.new do
        font_families.update(
          "Verdana" => {
            :bold => "/home/anna/Загрузки/tmp_fonts/verdanab.ttf",
            :italic => "/home/anna/Загрузки/tmp_fonts/verdanai.ttf",
            :normal  => "/home/anna/Загрузки/tmp_fonts/verdana.ttf" })
        font "Verdana", :size => 10
        move_down 10
        text "Ректору федерального государственного" 
        move_down 10
        text "бюджетного учреждения высшего"
        move_down 10
        text "профессионального образования"
        move_down 10
        text "«Московский государственный университет"
        move_down 10
        text "печати имени Ивана Федорова»"
        move_down 10
        text "К. В. Антипову"
        move_down 10
        text "от студента #{student.group.course} курса #{student.group.support} формы обучения"
        move_down 10
        text "#{student.group.speciality.faculty.abbreviation}, группы #{student.group.name}"
        move_down 10
        text "#{student.person.full_name}, #{support.birthday}"
        move_down 10
        text "паспорт #{support.series} #{support.number} выдан #{support.date} #{support.department},"
        move_down 10
        text "адрес регистрации: #{support.address}, #{support.phone}"
    end.render 
  end 

  def find_student
    @student = Student.find(params[:student_id])
  end

  def resource_params
    params.fetch(:supports, {}).permit(:student, :year, :month, :series,
                :number, :date, :department, :birthday, :address, :phone)
  end

end