class Office::OrdersController < ApplicationController
  load_and_authorize_resource class: 'Office::Order'

  def index
    @order_students = Office::OrderStudent.my_filter(params.merge(status: '3'))
    if @order_students.page(params[:page]).empty?
      @order_students = @order_students.page(1)
    else
      @order_students = @order_students.page(params[:page])
    end
  end

  def drafts
    @drafts = Office::Order.drafts
  end

  def underways
    @underways = Office::Order.underways
  end

  def entrance_protocol
    @item = @order.competitive_group.items.first if Office::Order.entrance.include? @order
    respond_to do |format|
      format.pdf
    end
  end

  def show
    @order = Office::Order.find(params[:order_id])
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
    @students = Student.includes([:person, :group]).where.not(student_group_id: params[:exception]).my_filter(params).page(params[:page])
  end

  def create
    students = {}
    params[:exceptions].each_with_index do |ex, i|
      student = Student.find(ex)
      students.merge! i => {order_student_student: student.person.id, order_student_student_group_id: student.id, order_student_cause: 0}
    end
    # raise students.inspect
    @order = Office::Order.create status: 1, responsible: current_user.positions.first.id, order_template: params[:template],
                                  order_department:  current_user.positions.first.department.id,
                                  students_in_order_attributes: students
    if @order.save
      redirect_to office_orders_path, notice: 'Проект приказа успешно создан.'
    else
      render action: :new
    end
  end

  def edit ; end

  def update
    @order.update(resource_params)
    if @order.save
      if can?(:sign, Office::Order) && @order.status == Office::Order::STATUS_SIGNED
        redirect_to edit_office_order_path(@order)
      elsif can?(:orders, Entrance::Campaign)
        redirect_to orders_entrance_campaigns_path
      else
        redirect_to office_orders_path, notice: 'Изменения сохранены.'
      end
    else
      render action: :edit
    end
  end

  def destroy
    @order.destroy

    redirect_to roles_path
  end

  def resource_params
    params.fetch(:office_order, {}).permit(:number, :editing_date, :signing_date, :status, :responsible, :template,
                 students_in_order_attributes: [:order_student_student, :order_student_student_group_id, :order_student_cause])
  end
end