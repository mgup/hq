class Library::CardsController < ApplicationController
  require 'tiny_tds'

  # ЗАМЕНИТЬ ТАБЛИЦУ READERS_old на READERS и добавить при INSERT поля MATRIX_STUDENT_ID, MATRIX_STUDENT_GROUP_ID
  def index
    if params[:student]
      @student = Student.find(params[:student])
      @client = TinyTds::Client.new(username: ENV['LIBRARY_USERNAME'], password: ENV['LIBRARY_PASSWORD'], dataserver: '192.168.200.36:1433', database: '[marc 1.11]')
      @query = "SELECT COUNT(*) as 'count' FROM dbo.READERS_old WHERE NAME = '#{@student.full_name}'"
    end
  end

  def create
    @student = Student.find(params[:student])
    client = TinyTds::Client.new(username: ENV['LIBRARY_USERNAME'], password: ENV['LIBRARY_PASSWORD'], dataserver: '192.168.200.36:1433', database: '[marc 1.11]')
    strange_num = client.execute("SELECT * FROM dbo.SPEC WHERE spec = #{@student.speciality.code.to_s[0,6]}").first['num']
    rdr = "99#{@student.group.speciality.faculty.id}#{strange_num < 10 ? strange_num : strange_num - 9}1#{Study::Discipline::CURRENT_STUDY_YEAR.to_s[2,2]}#{@student.group.library_form}"
    last_rdr_id = client.execute("SELECT MAX(SUBSTRING(RDR_ID,9,3)) AS max FROM dbo.READERS_old WHERE RDR_ID LIKE '#{rdr}%'").first['max']
    last_rdr_id = last_rdr_id ? last_rdr_id.to_i+1 : 0
    rdr_id = last_rdr_id < 100 ? (last_rdr_id < 10 ? "#{rdr}00#{last_rdr_id}" : "#{rdr}0#{last_rdr_id}") : "#{rdr}#{last_rdr_id}"
    client.execute("INSERT INTO dbo.READERS_old (RDR_ID, NAME, CODE) VALUES ('#{rdr_id}', '#{@student.full_name}, 'Студент')").insert
    redirect_to library_cards_path faculty: @student.group.speciality.faculty.id, speciality: @student.group.speciality.id, course: @student.group.course,
                                   form: @student.group.form, group: @student.group.id, student: @student.id
  end

end
