class Report::GzguController < ApplicationController
  # Форма №1. Сведения о приеме граждан на обучение по программам бакалавриата,
  # специалитета и магистратуры на места за счет федерального бюджета (приказ
  # Минобрнауки России от 30 января 2013 г. № 1424), бюджетов субъектов
  # Российской Федерации, местных бюджетов и по договорам об оказании платных
  # образовательных услуг
  def mon_pk_f1_2014_06_23
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root(id: 415) do
        # Выбираем все бюджетные конкурсные группы обычной приемной кампании.
        index = 1
        Entrance::Campaign.find(2014).items.find_all { |i| !i.payed? }.sort_by { |i| "#{i.direction.name} #{i.direction.new_code}" }.each do |item|
          next if item.direction.new_code.split('.')[1] == '06'

          next if [244350,237078,244351].include?(item.id)

          xml.lines(id: index) do
            mon_pk_f1_2014_06_23_line(xml, item)
          end

          index += 1
        end
      end
    end

    respond_to do |format|
      format.xml { render xml: builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip }
    end
  end

  # Форма №1a. Сведения о приеме граждан на обучение по программам аспирантуры,
  # ординатуры, ассистентуры-стажировки на места за счет федерального бюджета
  # (приказ Минобрнауки России от 27 января 2013 г. № 1417), бюджетов субъектов
  # Российской Федерации, местных бюджетов и по договорам об оказании платных
  # образовательных услуг.
  def mon_pk_f1a_2014_06_23
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root(id: 415) do
        # Выбираем все бюджетные конкурсные группы обычной приемной кампании.
        index = 1
        Entrance::Campaign.find(2014).items.sort_by { |i| "#{i.direction.name} #{i.direction.new_code}" }.each do |item|
          next unless item.direction.new_code.split('.')[1] == '06'

          xml.lines(id: index) do
            mon_pk_f1a_2014_06_23_line(xml, item)
          end

          index += 1
        end
      end
    end

    respond_to do |format|
      format.xml { render xml: builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip }
    end
  end

  # Форма №2. Сведения о среднем балле зачисленных на обучение по программам
  # бакалавриата и специалитета на места за счет федерального бюджета (приказ
  # Минобрнауки России от 30 января 2013 г. № 1424), бюджетов субъектов
  # Российской Федерации, местных бюджетов и по договорам об оказании платных
  # образовательных услуг.
  def mon_pk_f2_2014_06_23
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root(id: 415) do
        # Выбираем все бюджетные конкурсные группы обычной приемной кампании.
        index = 1
        Entrance::Campaign.find(2014).items.find_all { |i| !i.payed? }.sort_by { |i| "#{i.direction.name} #{i.direction.new_code}" }.each do |item|
          next if item.direction.new_code.split('.')[1] == '06'
          next if [244350,237078,244351].include?(item.id)

          xml.lines(id: index) do
            mon_pk_f2_2014_06_23_line(xml, item)
          end

          index += 1
        end
      end
    end

    respond_to do |format|
      format.xml { render xml: builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip }
    end
  end

  private

  def mon_pk_f1_2014_06_23_line(xml, item)
    xml.oo 415
    # xml.spec "#{item.id} #{item.direction.new_code} #{item.direction.name}"
    xml.spec item.direction.gzgu
    xml.fo case item.form
           when 11 then 1
           when 12 then 2
           when 10 then 3
           end
    xml.ff (item.payed? ? 2 : 1)

    field_payment = item.payed? ? 'paid' : 'budget'
    field_form = case item.form
                   when 11 then 'o'
                   when 12 then 'oz'
                   when 10 then 'z'
                 end

    total_places = item.send("number_#{field_payment}_#{field_form}")
    total_places += item.send("number_quota_#{field_form}")
    target_places = 0
    item.competitive_group.target_organizations.each do |org|
      org.items.where(direction_id: item.direction_id, education_level_id: item.education_level_id).each do |i|
        total_places += i.send("number_target_#{field_form}")
        target_places += i.send("number_target_#{field_form}")
      end
    end

    xml.p1_1 total_places
    xml.p1_2 item.number_quota_o
    xml.p1_3 target_places

    all_applications = 0
    quota_applications = 0
    target_applications = 0
    after_applications = 0
    enrolled_07_31 = 0
    enrolled_08_05 = 0
    enrolled_08_11 = 0
    enrolled_after = 0

    enrolled_without = 0
    enrolled_with_100 = 0
    enrolled_with_quota = 0
    enrolled_with_target = 0
    enrolled_with_olymp = 0
    item.applications.each do |a|
      if [4,6,8].include?(a.status_id)
        all_applications += 1
        quota_applications += 1 if a.benefits.first && 4 == a.benefits.first.benefit_kind_id
        target_applications += 1 unless a.competitive_group_target_item_id.nil?
      end

      if 8 == a.status_id && a.order_id
        case (a.order.order_signing || a.order.order_editing).to_date
        when Date.new(2014, 7, 31) then enrolled_07_31 += 1
        when Date.new(2014, 8, 5) then enrolled_08_05 += 1
        when Date.new(2014, 8, 11) then enrolled_08_11 += 1
        else enrolled_after += 1
        end

        enrolled_without += 1
        if a.benefits.first
          if [1,3].include?(a.benefits.first.benefit_kind_id)
            enrolled_without -= 1
          end

          case a.benefits.first.benefit_kind_id
            when 1 then enrolled_with_olymp += 1
            when 3 then enrolled_with_100 += 1
            when 4 then enrolled_with_quota += 1
          end
        end

        enrolled_with_target += 1 unless a.competitive_group_target_item_id.nil?
      end
    end

    xml.p2_1 all_applications
    xml.p2_2 quota_applications
    xml.p2_3 target_applications
    xml.p2_4 after_applications

    xml.p3_1 enrolled_07_31
    xml.p3_2 enrolled_08_05
    xml.p3_3 enrolled_08_11
    xml.p3_4 0

    xml.p4_2 enrolled_without
    xml.p4_3 enrolled_with_100
    xml.p4_4 enrolled_with_quota
    xml.p4_5 enrolled_with_target
    xml.p4_6 0
    xml.p4_7 0
    xml.p4_8 enrolled_with_olymp
  end

  def mon_pk_f1a_2014_06_23_line(xml, item)
    xml.oo 415
    # xml.spec "#{item.id} #{item.direction.new_code} #{item.direction.name}"
    xml.spec item.direction.gzgu
    xml.fo case item.form
             when 11 then 1
             when 12 then 2
             when 10 then 3
           end
    xml.ff (item.payed? ? 2 : 1)

    field_payment = item.payed? ? 'paid' : 'budget'
    field_form = case item.form
                   when 11 then 'o'
                   when 12 then 'oz'
                   when 10 then 'z'
                 end

    total_places = item.send("number_#{field_payment}_#{field_form}")
    total_places += item.send("number_quota_#{field_form}")
    target_places = 0
    item.competitive_group.target_organizations.each do |org|
      org.items.where(direction_id: item.direction_id, education_level_id: item.education_level_id).each do |i|
        total_places += i.send("number_target_#{field_form}")
        target_places += i.send("number_target_#{field_form}")
      end
    end

    xml.p1_1 total_places
    xml.p1_2 0

    all_applications = 0

    enrolled = 0
    item.applications.each do |a|
      all_applications += 1

      if 8 == a.status_id && a.order_id
        enrolled += 1
      end
    end

    xml.p2_1 all_applications
    xml.p2_2 0

    xml.p3_1 enrolled
    xml.p3_2 0

    xml.p4 0
  end

  def mon_pk_f2_2014_06_23_line(xml, item)
    xml.oo 415
    # xml.spec "#{item.id} #{item.direction.new_code} #{item.direction.name}"
    xml.spec item.direction.gzgu
    xml.fo case item.form
             when 11 then 1
             when 12 then 2
             when 10 then 3
           end
    xml.ff (item.payed? ? 2 : 1)

    enrolled = 0
    enrolled_contest = 0
    enrolled_contest_use = 0
    enrolled_contest_university = 0
    enrolled_contest_creative = 0
    enrolled_target_use = 0
    enrolled_target_university = 0
    enrolled_quota_use = 0
    enrolled_quota_university = 0
    enrolled_olymp = 0
    item.applications.find_all { |a| 8 == a.status_id && a.order_id }.each do |a|
      enrolled += 1

      if a.competitive_group_target_item_id.nil?
        if a.benefits.first && [1,4].include?(a.benefits.first.benefit_kind_id)
          # Зачислен льготник.
          if 4 == a.benefits.first.benefit_kind_id
            # Квота.
            if a.only_use?
              enrolled_quota_use += 1
            else
              enrolled_quota_university += 1
            end
          else
            enrolled_olymp += 1
          end
        else
          enrolled_contest += 1
          if a.only_use?
            enrolled_contest_use += 1
            if a.has_creative_exams?
              enrolled_contest_creative += 1
            end
          else
            enrolled_contest_university += 1
          end
        end
      else
        # Зачисленный целевик.
        if a.only_use?
          enrolled_target_use += 1
        else
          enrolled_target_university += 1
        end
      end
    end

    xml.p1_1 enrolled
    xml.p2_1 enrolled_contest
    xml.p2_2 enrolled_contest_use
    xml.p2_3 0
    xml.p2_4 enrolled_contest_university
    xml.p2_5 enrolled_contest_creative
    xml.p3_1 enrolled_target_use
    xml.p3_2 enrolled_target_university
    xml.p4_1 enrolled_quota_use
    xml.p4_2 enrolled_quota_university
    xml.p5   enrolled_olymp

    xml.p6_1 0
    xml.p6_2 0
    xml.p6_3 0
    xml.p6_4 0
    xml.p7_1 0
    xml.p7_2 0
    xml.p8   0
  end
end