# Расширение для моделей, которое создаёт в них дополнительные методы
# для выполнения более удобных запросов с помощью всего лишь одного хэша
# в качестве параметра.
module Filterable
  extend ActiveSupport::Concern

  # Методы-класса, которые добавляются в расширяемую модель.
  module ClassMethods
    def filter(conditions)
      conditions.reduce(all) do |query, (field, value)|
        method = "find_all_by_#{field}"
        if self.respond_to?(method)
          query.send(method, value)
        else
          query.where(field => value)
        end
      end
    end
  end
end
