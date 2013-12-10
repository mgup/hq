class My::SelectsController < ApplicationController
  YEAR = 2013
  load_resource

  before_filter :find_student
  skip_before_filter :authenticate_user!
  before_filter :authenticate_student!

  def index
    authorize! :manage, :student
  end

  def new
    authorize! :manage, :student
    choices = My::Choice.from_group(@student.group)
    @selected_choices = []
    selected_choices = @student.choices
    terms = choices.collect {|c| c.term}.uniq
    terms.each do |term|
      @selected_choices << selected_choices.where(optional_term: term)
    end
    @choices = []
    chosen_options = selected_choices.collect {|c| c.option}
    @all_choices = choices.collect {|c| c.option}.uniq.count
    if @all_choices != selected_choices.count
      variants = choices.collect {|c| c.option}.uniq
      variants -= chosen_options
      variants.each do |variant|
        @choices << choices.where(optional_option: variant)
      end
    end
  end

  def create
    selects = params[:choices]
    selects.each_value do |value|
      choice = My::Select.new student: @student.id,
                              choice: value
      choice.save
    end
    redirect_to new_my_student_select_path(@student)
  end

  def download_pdf
    find_student
      #@student = Student.find(params[:student_id])
      #@pdf = generate_pdf(@student.choices)
      #send_data(@pdf, filename: 'select.pdf', type: 'application/pdf')
  end

  private 
  #def generate_pdf(selects)
  #  student = Student.find(params[:student_id])
  #  Prawn::Document.new do
  #      font_families.update(
  #          'PT'=> {
  #          bold:  "#{Rails.root.join('app', 'assets', 'fonts', 'PTF75F.ttf')}",
  #          italic: "#{Rails.root.join('app', 'assets', 'fonts', 'PTF56F.ttf')}",
  #          normal:  "#{Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf') }"})
  #      font 'PT', size: 9
  #      move_down 10
  #      indent 350 do
  #        text "Декану #{student.group.speciality.faculty.abbreviation}"
  #        text 'имя декана'
  #        text "от студента группы #{student.group.name}"
  #        text "#{student.person.iname.rp} #{student.person.oname.rp} #{student.person.fname.rp}"
  #      end
  #      move_down 70
  #      text 'ЗАЯВЛЕНИЕ', align: :center
  #      move_down 50
  #      text "Прошу вас допустить меня к изучению нижеперечисленных дисциплин по выбору, предусмотренных учебным планом в #{YEAR}/#{YEAR+1} учебном году по направлению #{student.group.speciality.code} «#{student.group.speciality.name}».", indent_paragraphs: 10
  #      move_down 25
  #      selected_choices = []
  #      terms = selects.collect {|c| c.term}.uniq
  #      terms.each do |term|
  #        selected_choices << selects.where(optional_term: term)
  #      end
  #      selected_choices.each do |term|
  #        text 'В' + (term.first.term == 1 ? '' : 'о') + " #{term.first.term} семестре:", indent_paragraphs: 10
  #        term.each do |select|
  #          move_down 10
  #          text "— #{select.title}" + ((select == term.last && term == selected_choices.last) ? '.' : ';')
  #        end
  #      end
  #      move_down 50
  #      text "#{DateTime.now.strftime("%d.%m.%Y")}                                                                                                                                                             ___________________ / #{student.person.iname.ip[0]}. #{student.person.oname.ip[0]}. #{student.person.fname.ip}"
  #  end.render
  #end

  def find_student
    @student = current_student
  end

  def resource_params
    params.fetch(:selects, {}).permit(:student, :choice)
  end

end