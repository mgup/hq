# Добавляет к модели функциональность «имени» с учётом наличия имени,
# отчества (не обязательно), фамилии и поддержкой всех падежей.
# У модели предполагается наличие ассоциаций fname, iname и oname, которые ведут
# на записи в словаре (dictionary).
module Nameable
  extend ActiveSupport::Concern

  included do
    # Создаём методы для фамилии, имени и отчества во всех падежах.
    %w(last_name first_name patronym).each do |name|
      %w(ip rp dp vp tp pp).each do |form|
        define_method("#{name}_#{form}") { send(name, form.to_sym) }
      end
    end
  end

  # Фамилия человека в определённом падеже (ip, rp, dp, vp, tp, pp).
  #
  # Если у человека не известна или не заполнена фамилия в указанном падеже —
  # возвращаем именительный падеж.
  def last_name(form = :ip)
    if form == :ip
      send(:last_name_hint) rescue fname.send(form)
    else
      fname.send(form) unless fname.nil?
    end
  end

  # Имя человека в определённом падеже (ip, rp, dp, vp, tp, pp).
  #
  # Если у человека не известно или не заполнено имя в указанном падеже —
  # возвращаем именительный падеж.
  def first_name(form = :ip)
    if form == :ip
      send(:first_name_hint) rescue  iname.send(form)
    else
      iname.send(form) unless iname.nil?
    end
  end

  # Отчество человека в определённом падеже (ip, rp, dp, vp, tp, pp).
  #
  # Если у человека не известно или не заполнено отчество в указанном падеже —
  # возвращаем именительный падеж.
  def patronym(form = :ip)
    if form == :ip
      send(:patronym_hint) rescue oname.send(form)
    else
      oname.send(form) unless oname.nil?
    end
  end

  # Полное имя человека в формате «Иванов Иван Иванович» в определённом падеже
  # (ip, rp, dp, vp, tp, pp).
  def full_name(form = :ip)
    [last_name(form), first_name(form), patronym(form)].reject(&:nil?).join(' ')
  end

  # Сокращённое имя человека в формате «Иванов И. И.» в определённом падеже
  # (ip, rp, dp, vp, tp, pp). Употребляется при алфавитном перечислении имён
  # либо в «менее официальных» документах.
  def short_name(form = :ip)
    result = last_name(form) + ' ' + first_name(form)[0, 1] + '.'
    result += ' ' + patronym(form)[0, 1] + '.' unless patronym(form).nil?
    result
  end

  # Сокращённое имя человека в формате «И. И. Иванов» в определённом падеже
  # (ip, rp, dp, vp, tp, pp). Употребляется в официальных (персонализированных)
  # документах.
  def short_name_official(form = :ip)
    result = first_name(form)[0, 1] + '. '
    result += patronym(form)[0, 1] + '. ' unless patronym(form).nil?
    result + last_name(form)
  end
end