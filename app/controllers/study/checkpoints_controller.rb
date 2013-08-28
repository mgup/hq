class Study::CheckpointsController < ApplicationController
  before_filter :load_discipline
  load_and_authorize_resource :discipline
  load_and_authorize_resource through: :discipline
  #before_filter do
  #  raise '123'
  #end

   #before_filter :set_result

  def index
    render :new if @checkpoints.empty?
    #@checkpoints = @checkpoints.by_discipline(@discipline).order(:checkpoint_date)
    #if params[:id]
    #  @checkpoint = Study::Checkpoint.find(params[:id])
    #else
    #  @checkpoint = Study::Checkpoint.new
    #end
  end

  def new

  end

  def edit
    @checkpoints = @discipline.checkpoints.control
    @max_b = 0
    @min_b = 0
    @checkpoints.each do |c|
      @max_b += c.max.round
      @min_b += c.min.round
    end
    @error = (@max_b != @max or @min_b != @min) ? 'danger' : 'success'
  end

  def show
    if params[:study_checkpoint]
      study_checkpoint = params[:study_checkpoint]
      checkpoint = Study::Checkpoint.find(study_checkpoint[:id])
      checkpoint.update_attributes(checkpoint_type: study_checkpoint[:type],
                                   date: study_checkpoint[:date],
                                   name: study_checkpoint[:name], details: study_checkpoint[:details],)
      redirect_to study_discipline_checkpoints_path(@discipline)
    end
  end

  def update
    if params[:checkpoints]
      checkpoints = params[:checkpoints]
      checkpoints.each do |check|
        checkpoint=Study::Checkpoint.find(check[:id])
        checkpoint.update_attributes(check)
      end
      redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Сохранено'
    end
  end

  def create
    checkpoint = params[:study_checkpoint]
    min = checkpoint[:type]=='3' ? 11 : nil
    max = checkpoint[:type]=='3' ? 20 : nil
    @checkpoint = Study::Checkpoint.new checkpoint_type: checkpoint[:type],
                          date: checkpoint[:date], discipline: @discipline,
                          name: checkpoint[:name], details: checkpoint[:details],
                          min: min, max: max
    if @checkpoint.save
      redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Успешно создано'
    else
      redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Произошла ошибка'
    end
  end

  def resource_params
    params.fetch(:study_checkpoint, {}).permit( :name, :checkpoint_type, :date,
                                            :details, :min, :max)
  end

  def download_pdf
    @discipline = Study::Discipline.find(params[:discipline_id])
    @pdf = generate_pdf(@discipline)
    send_data(@pdf, filename: "#{@discipline.group.name}.pdf", type: 'application/pdf')
  end

  private
  def generate_pdf(discipline)
    Prawn::Document.new do
      font_families.update(
          'PT'=> {
              bold:  "#{Rails.root.join('app', 'assets', 'fonts', 'PTF75F.ttf')}",
              italic: "#{Rails.root.join('app', 'assets', 'fonts', 'PTF56F.ttf')}",
              normal:  "#{Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf') }"})
      font 'PT', size: 9
      text 'Федеральное государственное бюджетное образовательное учреждение высшего профессионального образования', size: 9, align: :center
      text '<u>«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА»</u>', size: 11, align: :center, inline_format: true
      text 'СОСТАВ УЧЕБНОЙ ГРУППЫ', size: 11, align: :center
      bounding_box [0, bounds.top - 45], width: bounds.width do
        draw_text "Группа: #{discipline.group.name}", at: [0, (bounds.top - 3)]
        draw_text " #{discipline.semester} семестр #{discipline.year}/#{discipline.year+1} г.", at: [445, (bounds.top - 3)]
      end
      move_down 8
      text "Дисциплина: #{discipline.name}"
      text "Преподаватель: #{discipline.teacher.full_name}"
      move_down 5
      i = 0
      students = []
      students << ['№', 'Фамилия, имя, отчество', 'Номер', '', '', '', '', '']
      Student.filter(group: discipline.group).each do |student|
        students << [i+1, student.person.full_name, student.id, '', '', '', '', '']
        i+=1
      end
      table students, header: true, column_widths: {0 => 20, 1 => 240, 2 => 40, 3 => 40, 4 => 40, 5 => 40, 6 => 40, 7 => 80}, cell_style: {padding: [1, 5, 1, 5]}
      move_down 10
      text 'Преподаватель __________________________'
    end.render
  end


  private

  def load_discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:discipline_id])
  end

  def set_result
    @max = 80
    @min = 44
  end
end