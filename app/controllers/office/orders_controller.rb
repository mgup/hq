class Office::OrdersController < ApplicationController
  load_and_authorize_resource class: 'Office::Order'
  before_filter :find_faculties, only: [:new, :index, :drafts, :underways]
  before_filter :find_templates, only: [:new, :index, :drafts, :underways]

  def index
    params[:from_date]  ||= "01.01.#{Date.today.year}"
    @order_students = Office::OrderStudent.my_filter(params.merge(order_status: Office::Order::STATUS_SIGNED))
    if params[:group_by_number] == '1'
      @order_students = @order_students.group(:order_student_order)
    end
    if @order_students.page(params[:page]).empty?
      @order_students = @order_students.page(1)
    else
      @order_students = @order_students.page(params[:page])
    end
  end

  def rebukes
    @orders = @orders.signed.my_filter(template: Office::Order::REPRIMAND_TEMPLATE)
  end

  def drafts
    params[:from_date]  ||= "01.01.#{Date.today.year}"
    @order_students = Office::OrderStudent.my_filter(params.merge(order_status: Office::Order::STATUS_DRAFT))
    @drafts = Office::Order.where(id: @order_students.collect{|x| x.order.id}.uniq)
    if @drafts.page(params[:page]).empty?
      @drafts = @drafts.page(1)
    else
      @drafts = @drafts.page(params[:page])
    end
  end

  def underways
    params[:from_date]  ||= "01.01.#{Date.today.year}"
    @order_students = Office::OrderStudent.my_filter(params.merge(order_status: Office::Order::STATUS_UNDERWAY))
    @underways = Office::Order.where(id: @order_students.collect{|x| x.order.id}.uniq)
    if @underways.page(params[:page]).empty?
      @underways = @underways.page(1)
    else
      @underways = @underways.page(params[:page])
    end
  end

  def entrance_protocol
    @item = @order.competitive_group.items.first if Office::Order.entrance.include? @order
    ap = @order.students.first.entrant.packed_application
    @applications = ap.competitive_group.items.first.applications.for_rating.rating(ap.education_form_id,
                                                                                    ap.is_payed ? '15' : '14',
                                                                                    ap.direction.id)

    a_out_of_competition = []
    a_special_rights = []
    a_organization = []
    a_contest_enrolled = []
    a_contest = []
    @applications.each do |a|
      if a.out_of_competition
        a_out_of_competition << a
      else
        if 0 != a.pass_min_score
          if a.special_rights
            a_special_rights << a
          elsif a.competitive_group_target_item
            a_organization << a
          else
            if a.order && a.order.signed?
              a_contest_enrolled << a
            else
              a_contest << a
            end
          end
        end
      end
    end

    if ap.out_of_competition
      @applications = a_out_of_competition
    elsif ap.special_rights
      @applications = a_special_rights
    elsif ap.competitive_group_target_item
      @applications = a_organization.find_all {|a| a.competitive_group_target_item_id == ap.competitive_group_target_item.id}
    else
      @applications = a_contest_enrolled + a_contest
    end

    #@applications = @order.students.map { |s| s.entrant.applications.for_rating.find_all { |a| a.order}.first }

    respond_to do |format|
      format.pdf
    end
  end

  def show
    respond_to do |format|
      format.pdf {
        filename = "Приказ №#{@order.id}"
        Dir.chdir(Rails.root)
        url = "#{Dir.getwd}/lib/xsl"
        xml = Tempfile.new(['order', '.xml'])
        File.open(xml.path, 'w') do |file|
          file.write @order.to_xml
        end
        command = "java -cp #{Dir.getwd}/vendor/fop/build/fop.jar"
        Dir.foreach('vendor/fop/lib') do |file|
          command << ":#{Dir.getwd}/vendor/fop/lib/#{file}" if (file.match(/.jar/))
        end
        command << ' org.apache.fop.cli.Main '
        command << " -c #{url}/configuration.xml"
        command << " -xml #{xml.path}"
        command << " -xsl #{url}/order_print.xsl"
        command << ' -pdf -'
        document = `#{command}`

        send_data document,
                  type: 'application/pdf',
                  filename: "#{filename}.pdf",
                  disposition: 'inline'

        xml.close
        xml.unlink
      }
      format.xml { render xml: @order.to_xml }
    end
  end

  def new
    params[:template] ||= current_user.is?(:soc_support_boss) ? Office::Order::REPRIMAND_TEMPLATE : 40
    @students = Student.includes([:person, :group]).where.not(student_group_id: params[:exception])
                       .my_filter(params).from_template(Office::OrderTemplate.find(params[:template])).page(params[:page])
  end

  def create
    count = 0
    students_in_order = Student.where(student_group_id: params[:exception])
    faculty = students_in_order.first.faculty.id
    if Office::OrderTemplate.find(params[:template]).template_check_speciality
      students_in_order.group_by(&:group).each do |_, group_students|
        if Office::OrderTemplate.find(params[:template]).template_check_tax
          group_students.group_by(&:payment).each do |_, payment_students|
            create_order_with_students(params[:template], payment_students)
            count += 1
          end
        else
          create_order_with_students(params[:template], group_students)
          count += 1
        end
      end
    else
      create_order_with_students(params[:template], students_in_order)
      count = 1
    end
    redirect_to office_drafts_path(faculty: faculty, template: params[:template]), notice: "#{count > 1 ? 'Проекты приказов' : 'Проект приказа'} успешно создан#{'ы' if count > 1}."
  end

  def edit ; end

  def update
    @order.update(resource_params)
    if @order.save
      if can?(:sign, Office::Order) && @order.status == Office::Order::STATUS_SIGNED
        redirect_to edit_office_order_path(@order)
      elsif can?(:orders, Entrance::Campaign) && @order.underway?
        redirect_to orders_entrance_campaigns_path
      elsif @order.underway?
        redirect_to office_underways_path, notice: 'Изменения сохранены.'
      elsif @order.draft?
        redirect_to office_drafts_path, notice: 'Изменения сохранены.'
      else
        redirect_to office_orders_path, notice: 'Изменения сохранены.'
      end
    else
      render action: :edit
    end
  end

  def destroy
    @order.destroy

    redirect_to office_drafts_path
  end

  def resource_params
    params.fetch(:office_order, {}).permit(:number, :editing_date, :signing_date, :status, :responsible, :template,
                 students_in_order_attributes: [:order_student_student, :order_student_student_group_id, :order_student_cause])
  end

  private

  def find_faculties
    @faculties = Department.faculties
    unless current_user.is?(:developer) || can?(:work, :all_faculties)
      user_departments = current_user.departments_ids
      @faculties = @faculties.find_all { |f| user_departments.include?(f.id) }
    end
    params[:faculty] ||= @faculties.first.id if @faculties.length < 2
    if params[:faculty].present?
      @faculty = Department.find(params[:faculty])
    end
  end
  
  def find_templates
    @templates = (current_user.is?(:soc_support) || current_user.is?(:soc_support_vedush) || current_user.is?(:soc_support_boss)) ? Office::OrderTemplate.where(template_id: Office::Order::REPRIMAND_TEMPLATE) : Office::OrderTemplate.all
    if (current_user.is?(:soc_support) || current_user.is?(:soc_support_vedush) || current_user.is?(:soc_support_boss))
      params[:template] = Office::Order::REPRIMAND_TEMPLATE
    end
  end

  def create_order_with_students(template, students)
    order_students = {}
    students.each_with_index do |student, i|
      order_students.merge! i => {order_student_student: student.person.id, order_student_student_group_id: student.id, order_student_cause: 0}
    end
    order = Office::Order.create status: 1, responsible: current_user.positions.where(acl_position_role: Office::Order::RESPONSIBLE_POSITION_ROLES).order(id: :desc).first.id, order_template: template,
                                  order_department:  current_user.positions.first.department.id,
                                  students_in_order_attributes: order_students
    order.save
  end
end
