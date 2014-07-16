require 'prawn'
require 'prawn/table' # Временно, пока это не вынесут в отдельный gem.

module Prawn
  module Rails
    # Хэлпер для генерации pdf-документов в представлениях.
    module PrawnHelper
      def prawn_document(opts = {})
        opts[:page_size]   ||= 'A4'
        opts[:page_layout] ||= :portrait

        # Боковые отуступы задаются в точках (pts), 72 точки —
        # это 2.54 сантиметра.
        opts[:margin] ||= [72.0 * 2.0 / 2.54,
                           72.0 * 1.5 / 2.54,
                           72.0 * 2.0 / 2.54,
                           72.0 * 2.7 / 2.54]

        download = opts.delete(:force_download)
        filename = opts.delete(:filename)
        pdf = (opts.delete(:renderer) || Prawn::Document).new(opts)
        initialize_fonts pdf

        yield pdf if block_given?

        disposition(download, filename) if download || filename

        pdf.render
      end

      def initialize_fonts(pdf)
        fonts = { normal: 'PTF55F.ttf',
                  italic: 'PTF56F.ttf',
                  bold: 'PTF75F.ttf' }.map do |variant, filename|
          [variant, ::Rails.root.join('app', 'assets', 'fonts', filename).to_s]
        end

        pdf.font_families.update('PTSerif'=> fonts.to_h)
        pdf.font 'PTSerif', size: 12
      end

      def disposition(download, filename)
        download = true if filename && nil == download
        disposition = download ? 'attachment;' : 'inline'
        disposition += %Q( filename="#{filename}") if filename
        headers['Content-Disposition'] = disposition
      end
    end

    # Обработчик pdf-представлений.
    class TemplateHandler
      class_attribute :default_format
      self.default_format = :pdf

      def self.call(template)
        template.source.strip
      end
    end
  end
end

unless Mime::Type.lookup_by_extension(:pdf)
  Mime::Type.register_alias 'application/pdf', :pdf
end

ActionView::Template.register_template_handler :prawn,
                                               Prawn::Rails::TemplateHandler

ActionView::Base.send :include, Prawn::Rails::PrawnHelper
