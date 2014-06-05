class Library::CardsController < ApplicationController
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

  # ЗАМЕНИТЬ ТАБЛИЦУ READERS_old на READERS и добавить при INSERT поля MATRIX_STUDENT_ID, MATRIX_STUDENT_GROUP_ID
  def index
    @client = TinyTds::Client.new(username: ENV['LIBRARY_USERNAME'], password: ENV['LIBRARY_PASSWORD'], dataserver: '192.168.200.36:1433', database: '[marc 1.11]')
    if params[:student]
      @student = Student.find(params[:student])
      if @student.admission_year < 2012
        # strange_num = @client.execute("SELECT * FROM dbo.SPEC WHERE spec = #{@student.speciality.code.to_s[0,6]}").first['num']
        # rdr = "99%#{strange_num < 10 ? strange_num : strange_num - 9}1#{@student.admission_year.to_s[2,2]}#{@student.group.library_form}"
        @query = "SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{@student.full_name}'"
      else
        @query = "SELECT RDR_ID FROM dbo.READERS WHERE MATRIX_STUDENT_GROUP_ID = #{@student.id}"
      end
    end
    if params[:user_name]
      users = User.by_name(params[:user_name])
      @users = []
      users.each do |user|
        variants = @client.execute("SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{user.full_name}'").collect{|x| x['RDR_ID']}
        @users << {id: user.id, name: user.full_name, variants: variants, department: user.departments.collect{|d| d.abbreviation}.join(', ')}
      end
    end
  end

  def create
    @student = Student.find(params[:student])
    client = TinyTds::Client.new(username: ENV['LIBRARY_USERNAME'], password: ENV['LIBRARY_PASSWORD'], dataserver: '192.168.200.36:1433', database: '[marc 1.11]')
    strange_num = client.execute("SELECT * FROM dbo.SPEC WHERE spec = #{@student.speciality.code.to_s[0,6]}").first['num']
    rdr = "99#{@student.group.speciality.faculty.id}#{strange_num < 10 ? strange_num : strange_num - 9}1#{@student.admission_year.to_s[2,2]}#{@student.group.library_form}"
    last_rdr_id = client.execute("SELECT MAX(SUBSTRING(RDR_ID,9,3)) AS max FROM dbo.READERS WHERE RDR_ID LIKE '#{rdr}%'").first['max']
    last_rdr_id = last_rdr_id ? last_rdr_id.to_i+1 : 0
    rdr_id = last_rdr_id < 100 ? (last_rdr_id < 10 ? "#{rdr}00#{last_rdr_id}" : "#{rdr}0#{last_rdr_id}") : "#{rdr}#{last_rdr_id}"
    client.execute("INSERT INTO dbo.READERS (RDR_ID, NAME, CODE, MATRIX_STUDENT_ID, MATRIX_STUDENT_GROUP_ID) VALUES ('#{rdr_id}', '#{@student.full_name}, 'Студент', #{@student.person.id}, #{@student.id})").insert
    redirect_to library_cards_path faculty: @student.group.speciality.faculty.id, speciality: @student.group.speciality.id, course: @student.group.course,
                                   form: @student.group.form, group: @student.group.id, student: @student.id
  end

  def print
    @reader = params[:student] ? Student.find(params[:student]) : User.find(params[:user])
    client = TinyTds::Client.new(username: ENV['LIBRARY_USERNAME'], password: ENV['LIBRARY_PASSWORD'], dataserver: '192.168.200.36:1433', database: '[marc 1.11]')
    if (params[:student] && @reader.admission_year < 2012) || params[:user]
      query = "SELECT RDR_ID FROM dbo.READERS WHERE NAME = '#{@reader.full_name}'"
    else
      query = "SELECT RDR_ID FROM dbo.READERS WHERE MATRIX_STUDENT_GROUP_ID = #{@reader.id}"
    end
    if params[:index]
      @rdr_id = client.execute(query).collect{|x| x}[params[:index].to_i]
    else
      @rdr_id = client.execute(query).last['RDR_ID']
    end
    barcode = Barby::Code128B.new(@rdr_id)
    @blob = Barby::PngOutputter.new(barcode).to_png(height: 65, margin: 0)
    File.open('app/assets/images/library/barcode.png', 'w'){|f| f.write @blob }
  end

  def print_card
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

end
