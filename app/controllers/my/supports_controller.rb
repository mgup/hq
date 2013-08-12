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
      redirect_to "/my/student/#{@student.id}/support/download_pdf", notice: 'Успешно создано'
    else
       redirect_to new_my_student_support_path(@student), notice: 'Произошла ошибка'
    end
  end

def download_pdf
      @student = Student.find(params[:student_id])
      @pdf = generate_pdf(@student.supports.last)
      send_data(@pdf, filename: 'support.pdf', type: 'application/pdf')
  end

  private 
  def generate_pdf(support)
    student = Student.find(support.support_student)
    Prawn::Document.new do
        font_families.update(
          'Verdana'=> {
            bold: '/home/anna/Загрузки/tmp_fonts/verdanab.ttf',
            italic: '/home/anna/Загрузки/tmp_fonts/verdanai.ttf',
            normal:  '/home/anna/Загрузки/tmp_fonts/verdana.ttf' })
        font 'Verdana', size: 9
        move_down 10
        indent 350 do 
          text 'Ректору федерального государственного' 
          text 'бюджетного учреждения высшего'
          text 'профессионального образования'
          text '«Московский государственный университет'
          text 'печати имени Ивана Федорова»'
          text 'К. В. Антипову'
          text "от студента #{student.group.course} курса #{student.group.support} формы обучения"
          text "#{student.group.speciality.faculty.abbreviation}, группы #{student.group.name}"
          text "#{student.person.iname.rp} #{student.person.oname.rp} #{student.person.fname.rp} , #{support.birthday}"
          text "паспорт #{support.series} #{support.number} выдан #{support.date} #{support.department},"
          text "адрес регистрации: #{support.address}, #{support.phone}"
        end
        move_down 25
        text 'ЗАЯВЛЕНИЕ', align: :center
        move_down 10
        text 'о выплате материальной помощи', align: :center
        move_down 25
        cause = ''
        support.options.each do |option|
          cause << (student.person.male? ? option.cause.pattern : (option.cause.patternf == nil ? option.cause.pattern : option.cause.patternf))
          cause << ', '
        end
        cause = cause[0..-3]
        text "Прошу Вас предоставить мне материальную помощь в связи с тем, что #{cause}.", indent_paragraphs: 10   
        move_down 25
        text 'Приложение:', indent_paragraphs: 10
        move_down 10
        text '— копия паспорта (страницы 2-3 и 4-5);'
        support.options.each do |option|
          option.cause.reasons.each do |reason|
            move_down 10
            text "— #{reason.pattern}" + ((option == support.options.last && reason == option.cause.reasons.last) ? '.' : ';')
          end
        end
        move_down 30
        text "#{DateTime.now.strftime("%d.%m.%Y")}                                                                                           _________________/#{student.person.iname.ip[0]}. #{student.person.oname.ip[0]}. #{student.person.fname.ip}"
        move_down 40 
        text 'Резолюция старосты группы:'
        move_down 25 
        text '___________________________________________________________________________________________'
        move_down 25
        text '«__» _______________ 2013г.                                                         _________________/________________'
        move_down 40 
        text 'Резолюция деканата:'
        move_down 25 
        text '___________________________________________________________________________________________'
        move_down 25
        text '«__» _______________ 2013г.                                                         _________________/________________'
    
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