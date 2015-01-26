# Расширение для моделей, которое создаёт в них дополнительные методы
# для выполнения более удобных запросов с помощью всего лишь одного хэша
# в качестве параметра.
module Filterable
  extend ActiveSupport::Concern

  # Методы-класса, которые добавляются в расширяемую модель.
  module ClassMethods
    def filter(conditions)
      skipped_keys = ['utf8']

      conditions.reduce(@relation) do |query, (field, value)|
        if skipped_keys.include?(field) || value.blank?
          query
        else
          # Заменяем все псевдонимы на оригинальные названия полей.
          field ||= self.attribute_aliases[field]

          # По-хорошему, здесь надо бы сделать проверку на существование полей.
          # Но, во-первых, сфигали их запрашивать, если их не существует?
          # Во-вторых, база и так выдаст ошибку, мы её увидим и тогда
          # смотри «во-первых».
          # if self.attribute_names.include?(field)
            method = "find_all_by_#{field}"
            if self.respond_to?(method)
              query.send(method, value)
            else
              query.where(field => value)
            end
          # else
          #   query
          # end
        end
      end
    end
  end
end
