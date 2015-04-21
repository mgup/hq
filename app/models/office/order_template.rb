module Office
  class OrderTemplate < ActiveRecord::Base
    self.table_name = 'template'

    alias_attribute :id, :template_id
    alias_attribute :name, :template_name

    has_many :orders, class_name: 'Office::Order', foreign_key: :order_template
    has_many :reasons, class_name: 'Office::Reason', foreign_key: :template_reason_template
    has_many :causes, class_name: 'Office::Cause', foreign_key: :template_cause_template
    has_many :template_statuses, class_name: 'Office::TemplateStudentStatus', foreign_key: :template_id
    has_many :statuses, class_name: 'EducationStatus', through: :template_statuses

    # TODO Откуда здесь различие? Это не логично. Нужно оставить что-то одно.
    has_one :current_xsl, -> { order('order_xsl_time DESC').limit(1) }, class_name: 'Office::OrderXsl', foreign_key: :order_xsl_template
    has_many :xsl, -> { order('order_xsl_time DESC').limit(1) }, class_name: 'Office::OrderXsl', foreign_key: :order_xsl_template
    accepts_nested_attributes_for :xsl, update_only: false

    default_scope { where(template_active: 1).order(:template_name) }

    def to_nokogiri
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.order_template do
          xml.id_ id
          xml.name name
          xml.check_group template_check_speciality

          [:reasons, :causes].each do |name|
            xml.send(name) do
              send(name).each { |i| xml << i.to_nokogiri.root.to_xml }
            end
          end
        end
      end

      builder.doc
    end

    delegate :to_xml, to: :to_nokogiri
  end
end
