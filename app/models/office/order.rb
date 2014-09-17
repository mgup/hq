class Office::Order < ActiveRecord::Base
  self.table_name = 'order'

  STATUS_DRAFT    = 1
  STATUS_UNDERWAY = 2
  STATUS_SIGNED   = 3

  ENTRANCE_TEMPLATE = 16
  PROBATION_TEMPLATE = 40

  alias_attribute :id,      :order_id
  alias_attribute :version, :order_revision
  alias_attribute :number,  :order_number
  alias_attribute :status,  :order_status
  alias_attribute :editing_date, :order_editing
  alias_attribute :signing_date, :order_signing
  alias_attribute :responsible,  :order_responsible

  belongs_to :template, class_name: 'Office::OrderTemplate',
                        foreign_key: :order_template

  has_many :students_in_order, class_name: 'Office::OrderStudent',
           foreign_key: :order_student_order, dependent: :destroy
  accepts_nested_attributes_for :students_in_order
  has_many :students, class_name: 'Student', through: :students_in_order

  has_many :order_reasons, class_name: 'Office::OrderReason',
           foreign_key: :order_reason_order, dependent: :destroy
  has_many :reasons, class_name: 'Office::Reason', through: :order_reasons

  has_many :metas, class_name: 'Office::OrderMeta',
           foreign_key: :order_meta_order, primary_key: :order_id, dependent: :destroy
  accepts_nested_attributes_for :metas

  scope :drafts, -> { where(order_status: STATUS_DRAFT) }
  scope :underways, -> { where(order_status: STATUS_UNDERWAY) }
  scope :signed, -> { where(order_status: STATUS_SIGNED) }

  scope :entrance, -> { where(order_template: ENTRANCE_TEMPLATE) }
  scope :from_year_and_month, -> year, month { where('order_editing > ? AND (order_signing > ? OR order_signing IS NULL)', DateTime.new(year, month, 1, 0, 0, 0, 0), DateTime.new(year, month, 1, 0, 0, 0, 0)) }

  scope :my_filter, -> filters {
    cond = all

    if filters.key?(:template) && filters[:template] != ''
      cond = cond.where(order_template: filters[:template])
    end

    if filters.key?(:order_status) && filters[:order_status] != ''
      cond = cond.where(order_status: filters[:order_status].to_i)
    end

    if filters.key?(:from_date) && filters[:from_date] != ''
      cond = cond. where('order_editing >= ? AND (order_signing >= ? OR order_signing IS NULL)', DateTime.strptime(filters[:from_date], '%d.%m.%Y'), DateTime.strptime(filters[:from_date], '%d.%m.%Y'))
    end

    if filters.key?(:till_date) && filters[:till_date] != ''
      cond = cond. where('(order_editing <= ? AND order_signing IS NULL) OR order_signing <= ?', DateTime.strptime(filters[:till_date], '%d.%m.%Y'), DateTime.strptime(filters[:till_date], '%d.%m.%Y'))
    end

    cond
  }



  def draft?
    STATUS_DRAFT == status
  end

  def underway?
    STATUS_UNDERWAY == status
  end

  def signed?
    STATUS_SIGNED == status
  end

  def full_id
    "#{id}–#{version}"
  end

  def name
    template.name
  end

  # Форма обучения, к которой относится приказ.
  def education_form
    # Если для приказа не актуальна проверка формы обучения, †то nil.
    return nil unless template.check_form

    # TODO По-хорошему, нужно всё-таки добавлять к самому приказу его форму.
    forms = students.map(&:education_form).uniq

    if forms.size > 1
      fail 'Студенты с разными формами обучения в одном приказе.'
    end

    forms.first
  end

  # Основа обучения, к которой относится приказ.
  def education_source

  end

  # Направление обучения, к которому относится приказ.
  def direction

  end

  def competitive_group
    Entrance::CompetitiveGroup.find(metas.for_entrance.last.text)
  end

  def to_nokogiri
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.order do
        xml.id_         id
        xml.version     version
        xml.revision     version
        xml.responsible responsible
        xml.status      status
        xml << template.to_nokogiri.root.to_xml

        xml.students do
          students.each { |student| xml << student.to_nokogiri.root.to_xml }
        end

        if template.id == PROBATION_TEMPLATE
          xml.groups do
            students.first.group.speciality.groups.filter(course: students.first.group.course+1).each { |group| xml << group.to_nokogiri_empty.root.to_xml }
          end
        end

        xml.metas do
          metas.each { |meta| xml << meta.to_nokogiri.root.to_xml }
        end
        # xml.reasons do
        #   reasons.each { |reason| xml << reason.to_nokogiri.root.to_xml }
        # end
        xml.text_
        xml.signature_
        # xml.protocol_
        if template.id == ENTRANCE_TEMPLATE
          xml.act_
        end
      end
    end

    Nokogiri::XSLT(template.current_xsl.stylesheet).transform(builder.doc)
  end

  def to_xml
    xml = to_nokogiri

    xml.css('employee').each do |node|
      # role = Role.by_name(node.xpath('role').inner_text).first
      users = User.all
      if !node.xpath('role').empty?
        if !node.xpath('department').empty?
          position = Position.from_role(node.xpath('role').inner_text).
            where('acl_position_department = ?', node.xpath('department').inner_text).first
          users = [position.user]
        else
          users = users.from_role(node.xpath('role').inner_text)
          position = Position.from_role(node.xpath('role').inner_text).first
        end
      elsif !(node.xpath('position').empty? || node.xpath('position').inner_text == '')
        users = users.from_position(node.xpath('position').inner_text)
        position = Position.find(node.xpath('position').inner_text)
      elsif !(node.xpath('department').empty? || node.xpath('department').inner_text == '')
        users = users.from_department(node.xpath('department').inner_text)
      end

      unless users.empty? || users == User.all || users.nil?
        user = users.first
        id = Nokogiri::XML::Node.new 'id', node
        id.content = user.id
        phone = Nokogiri::XML::Node.new 'phone', node
        phone.content = user.phone
        name = Nokogiri::XML::Node.new 'name', node
        name.content = user.short_name_official
        title = Nokogiri::XML::Node.new 'title', node
        title.content = position.title
        department = Nokogiri::XML::Node.new 'department_short_name', node
        department.content = position.department.short_name_rp
        node << id << phone << name << title << department
      end
    end
    xml.to_xml
  end

  def to_html
    xslt = Nokogiri::XSLT(File.read('lib/xsl/order_view.xsl'))
    xml = to_nokogiri

    xml.css('employee').each do |node|
      # role = Role.by_name(node.xpath('role').inner_text).first
      users = User.all
      if !node.xpath('role').empty?
        if !node.xpath('department').empty?
          position = Position.from_role(node.xpath('role').inner_text).
              where('acl_position_department = ?', node.xpath('department').inner_text).first
          users = [position.user]
        else
          users = users.from_role(node.xpath('role').inner_text)
          position = Position.from_role(node.xpath('role').inner_text).first
        end
      elsif !(node.xpath('position').empty? || node.xpath('position').inner_text == '')
        users = users.from_position(node.xpath('position').inner_text)
        position = Position.find(node.xpath('position').inner_text)
      elsif !(node.xpath('department').empty? || node.xpath('department').inner_text == '')
        users = users.from_department(node.xpath('department').inner_text)
      end

      unless users.empty? || users == User.all || users.nil?
        user = users.first
        id = Nokogiri::XML::Node.new 'id', node
        id.content = user.id
        phone = Nokogiri::XML::Node.new 'phone', node
        phone.content = user.phone
        name = Nokogiri::XML::Node.new 'name', node
        name.content = user.short_name_official
        title = Nokogiri::XML::Node.new 'title', node
        title.content = position.title
        department = Nokogiri::XML::Node.new 'department_short_name', node
        department.content = position.department.short_name_rp
        node << id << phone << name << title << department
      end
    end
    xslt.transform(xml).root.to_html.html_safe
  end
end