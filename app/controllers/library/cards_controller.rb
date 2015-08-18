class Library::CardsController < ApplicationController
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

  # ПРОВЕРИТЬ СОХРАНЯЕТСЯ ЛИ В БАЗУ!!!
  def index
    authorize! :index, :library
    connect_to_db
    if params[:student]
      @student = Student.find(params[:student])
      if @student.admission_year < 2012
        @query = "SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{@student.full_name}'"
      else
        @query = "SELECT RDR_ID FROM dbo.READERS WHERE MATRIX_STUDENT_GROUP_ID = #{@student.id}"
      end
    elsif  params[:user_name]
      users = User.by_name(params[:user_name])
      @users = []
      users.each do |user|
        variants = @client.execute("SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{user.full_name}'").collect{|x| x['RDR_ID']}
        @users << {id: user.id, name: user.full_name, variants: variants, department: user.departments.collect{|d| d.abbreviation}.join(', ')}
      end
    elsif params[:student_name]
      students = Person.by_name(params[:student_name]).collect{|p| p.students.first}.compact
      @students = []
      students.each do |student|
        variants = @client.execute("SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{student.full_name}'").collect{|x| x['RDR_ID']}
        @students << {id: student.id, name: student.full_name, variants: variants, group: student.group.name}
      end
    end
  end

  def create
    authorize! :create, :library
    connect_to_db
    if params[:student]
      @student = Student.find(params[:student])
      # if [122, 2708, 2709].include?(@student.speciality.id)
      #   strange_num = 5
      # else
      #   strange_num = @client.execute("SELECT * FROM dbo.SPEC WHERE spec = #{@student.speciality.code.to_s.tr('.', '')}").first['num']
      #   strange_num = (strange_num < 10 ? strange_num : strange_num - 9)
      # end
      # rdr = "99#{@student.group.speciality.faculty.id}#{strange_num}1#{@student.admission_year.to_s[2,2]}#{@student.group.library_form}"
      # last_rdr_id = @client.execute("SELECT MAX(SUBSTRING(RDR_ID,9,3)) AS max FROM dbo.READERS WHERE RDR_ID LIKE '#{rdr}%'").first['max']
      # last_rdr_id = last_rdr_id ? last_rdr_id.to_i+1 : 1
      # rdr_id = last_rdr_id < 100 ? (last_rdr_id < 10 ? "#{rdr}00#{last_rdr_id}" : "#{rdr}0#{last_rdr_id}") : "#{rdr}#{last_rdr_id}"
      rdr_id = '100' + @student.id.to_s
      @client.execute("INSERT INTO dbo.READERS (RDR_ID, NAME, CODE, MATRIX_STUDENT_ID, MATRIX_STUDENT_GROUP_ID) VALUES ('#{rdr_id}', '#{@student.full_name}', 'Студент', #{@student.person.id}, #{@student.id})").insert
      redirect_to library_cards_path faculty: @student.group.speciality.faculty.id, speciality: @student.group.speciality.id, course: @student.group.course,
                                   form: @student.group.form, group: @student.group.id, student: @student.id, reader: 1
    elsif params[:user]
      @user = User.find(params[:user])
      # department = @user.departments.first.id < 10 ? "0#{@user.departments.first.id}" : @user.departments.first.id
      # rdr = "99#{department}2#{Study::Discipline::CURRENT_STUDY_YEAR.to_s[2,2]}0"
      # last_rdr_id = @client.execute("SELECT MAX(SUBSTRING(RDR_ID,9,3)) AS max FROM dbo.READERS WHERE RDR_ID LIKE '#{rdr}%'").first['max']
      # last_rdr_id = last_rdr_id ? last_rdr_id.to_i+1 : 1
      # rdr_id = last_rdr_id < 100 ? (last_rdr_id < 10 ? "#{rdr}00#{last_rdr_id}" : "#{rdr}0#{last_rdr_id}") : "#{rdr}#{last_rdr_id}"
      rdr_id = '200' + @user.id.to_s
      @client.execute("INSERT INTO dbo.READERS (RDR_ID, NAME, CODE) VALUES ('#{rdr_id}', '#{@user.full_name}', 'Сотрудник')").insert
      redirect_to library_cards_path user_name: @user.last_name, reader: 2
    end
  end

  def print
    authorize! :show, :library
    @reader = params[:student] ? Student.find(params[:student]) : User.find(params[:user])
    connect_to_db
    if (params[:student] && @reader.admission_year < 2012) || params[:user]
      query = "SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{@reader.full_name}'"
    else
      query = "SELECT RDR_ID FROM dbo.READERS WHERE MATRIX_STUDENT_GROUP_ID = #{@reader.id}"
    end
    if params[:index]
      @rdr_id = @client.execute(query).collect{|x| x}[params[:index].to_i]['RDR_ID']
    else
      @rdr_id = @client.execute(query).collect{|x| x}.last['RDR_ID']
    end
    barcode = Barby::Code128B.new(@rdr_id)
    @blob = Barby::PngOutputter.new(barcode).to_png(height: 65, margin: 0)
    File.open('app/assets/images/library/barcode.png', 'w'){|f| f.write @blob }
  end

  def print_card
    authorize! :show, :library
    @rdr_id = params[:rdr_id]
    barcode = Barby::Code128B.new(@rdr_id)
    @blob = Barby::PngOutputter.new(barcode).to_png(height: 65, margin: 0)
    File.open('app/assets/images/library/barcode.png', 'w'){|f| f.write @blob }
    @reader_last_name = params[:last_name]
    @reader_first_name = params[:first_name]
    @reader_patronym = params[:patronym]
    respond_to do |format|
      format.pdf
    end
  end

  def print_all
    authorize! :show, :library
    @group = Group.find(params[:group]) if params[:group]
    respond_to do |format|
      format.html
      format.pdf
    end
  end

  private

  def connect_to_db
    @client = TinyTds::Client.new(username: ENV['LIBRARY_USERNAME'], password: ENV['LIBRARY_PASSWORD'], dataserver: '192.168.200.211:1444', database: '[Lib19]')
  end

end
