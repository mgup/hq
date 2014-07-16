require 'prawn'

module Prawn
  module Rails
    # Хэлпер для генерации pdf-документов в представлениях.
    module PrawnHelper
      def prawn_document(opts = {})
        download = opts.delete(:force_download)
        filename = opts.delete(:filename)
        pdf = (opts.delete(:renderer) || Prawn::Document).new(opts)
        yield pdf if block_given?

        disposition(download, filename) if download || filename

        pdf.render
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
