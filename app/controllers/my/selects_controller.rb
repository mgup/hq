class My::SelectsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_student

  def index ; end

  def new
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


  private

  def find_student
    @student = Student.find(params[:student_id])
  end

  def resource_params
    params.fetch(:selects, {}).permit(:student, :choice)
  end

end