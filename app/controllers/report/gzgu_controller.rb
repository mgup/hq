class Report::GzguController < ApplicationController

  def mon_pk
    xitems = []
    Entrance::Campaign.find(2014).items.sort_by { |i| "#{i.direction.name} #{i.direction.new_code} #{i.payed? ? '2' : '1'}" }.each do |item|
      # Выкидываем профессиональное обучение, по которому у нас не было набора.
      next if [244350,237078,244351].include?(item.id)

      xitems << item

      if 237075 == item.id
        # item2 = item.dup
        # item2.education_type_id = 19
        xitems << item
      end
    end
    # fail '123'

    data = []
    polygraf_parsed = false
    xitems.each do |item|
      # Выкидываем профессиональное обучение, по которому у нас не было набора.
      # next if [244350,237078,244351].include?(item.id)

      line = {
        # oo: 415,
        education_type: item.education_type.id,
        education_type_name: item.education_type.name,
        direction: item.direction,
        ff: EducationSource.find(item.payed? ? 15 : 14),
        fo: EducationForm.find(item.form)
      }

      field_payment = item.payed? ? 'paid' : 'budget'
      field_form = case item.form
                     when 11 then 'o'
                     when 12 then 'oz'
                     when 10 then 'z'
                   end

      line[:total_places] = item.send("number_#{field_payment}_#{field_form}")
      line[:total_places] += item.send("number_quota_#{field_form}")
      line[:target_places] = 0
      if 237075 == item.id
        if polygraf_parsed
          # Второй проход.

        else
          item.competitive_group.target_organizations.each do |org|
            org.items.where(direction_id: item.direction_id, education_level_id: item.education_type_id).each do |i|
              line[:total_places] += i.send("number_target_#{field_form}")
              line[:target_places] += i.send("number_target_#{field_form}")
            end
          end
        end
      else
        item.competitive_group.target_organizations.each do |org|
          org.items.where(direction_id: item.direction_id, education_level_id: item.education_type_id).each do |i|
            line[:total_places] += i.send("number_target_#{field_form}")
            line[:target_places] += i.send("number_target_#{field_form}")
          end
        end
      end

      line[:quota_places] = item.number_quota_o

      line[:all_applications] = 0
      line[:quota_applications] = 0
      line[:target_applications] = 0
      line[:after_applications] = 0
      line[:enrolled_all] = 0
      line[:enrolled_07_31] = 0
      line[:enrolled_08_05] = 0
      line[:enrolled_08_11] = 0
      line[:enrolled_after] = 0

      line[:enrolled_contest_without_100] = 0
      line[:enrolled_contest_with_100] = 0
      line[:enrolled_with_quota] = 0
      line[:enrolled_with_target] = 0
      line[:enrolled_with_olymp] = 0

      line[:pass_points] = []
      line[:pass_points_100] = []

      line[:enrolled_contest] = 0
      line[:enrolled_contest_use] = 0
      line[:enrolled_contest_university] = 0
      line[:enrolled_contest_creative] = 0
      line[:enrolled_target_use] = 0
      line[:enrolled_target_university] = 0
      line[:enrolled_quota_use] = 0
      line[:enrolled_quota_university] = 0

      line[:contest_use] = []
      line[:contest_use_creative] = []
      line[:target_use] = []
      line[:quota_use] = []

      if 237075 == item.id
        if polygraf_parsed
          # Второй проход.
          appls = item.applications.where('prikladnoy = 1')
        else
          appls = item.applications.where('prikladnoy = 0')
        end
      else
        appls = item.applications
      end

      appls.each do |a|
        if [4,6,8].include?(a.status_id)
          line[:all_applications] += 1
          line[:quota_applications] += 1 if a.benefits.first && 4 == a.benefits.first.benefit_kind_id
          line[:target_applications] += 1 unless a.competitive_group_target_item_id.nil?
        end

        if 8 == a.status_id && a.order_id
          line[:enrolled_all] += 1

          exams = a.abitexams
          exams_use = exams.find_all { |r| r.use? }
          exams_use_creative = exams.find_all { |r| r.use? || r.exam.creative }

          if a.benefits.first && 1 == a.benefits.first.benefit_kind_id

          else
            line[:pass_points] << exams.map { |r| r.score }.sum
            line[:pass_points_100] << (1.0 * exams.map { |r| r.score }.sum / exams.size)
          end

          case (a.order.order_signing || a.order.order_editing).to_date
            when Date.new(2014, 7, 31) then line[:enrolled_07_31] += 1
            when Date.new(2014, 8, 5) then line[:enrolled_08_05] += 1
            when Date.new(2014, 8, 11) then line[:enrolled_08_11] += 1
            else line[:enrolled_after] += 1
          end

          line[:enrolled_contest_without_100] += 1
          if a.benefits.first
            if [1,3,4].include?(a.benefits.first.benefit_kind_id)
              line[:enrolled_contest_without_100] -= 1
            end

            case a.benefits.first.benefit_kind_id
              when 1 then line[:enrolled_with_olymp] += 1
              when 3 then line[:enrolled_contest_with_100] += 1
              when 4 then line[:enrolled_with_quota] += 1
            end
          end

          unless a.competitive_group_target_item_id.nil?
            line[:enrolled_with_target] += 1
            line[:enrolled_contest_without_100] -= 1
          end

          if a.competitive_group_target_item_id.nil?
            if a.benefits.first && [1,4].include?(a.benefits.first.benefit_kind_id)
              # Зачислен льготник.
              if 4 == a.benefits.first.benefit_kind_id
                if exams_use.size > 0
                  line[:quota_use] << 1.0 * exams_use.map { |r| r.score }.sum / exams_use.size
                end

                # Квота.
                if a.only_use?
                  line[:enrolled_quota_use] += 1
                else
                  line[:enrolled_quota_university] += 1
                end
              else
                # line[:enrolled_olymp] += 1
              end
            else
              line[:enrolled_contest] += 1
              if a.only_use?
                if a.has_creative_exams?
                  line[:enrolled_contest_creative] += 1
                  # line[:contest_use_creative] << 1.0 * exams_use_creative.map { |r| r.score }.sum / exams_use_creative.size
                  line[:contest_use_creative] << 1.0 * exams_use.map { |r| r.score }.sum / exams_use.size
                else
                  line[:enrolled_contest_use] += 1
                  line[:contest_use] << 1.0 * exams_use.map { |r| r.score }.sum / exams_use.size
                end
              else
                line[:enrolled_contest_university] += 1
              end
            end
          else
            # Зачисленный целевик.
            if exams_use.size > 0
              line[:target_use] << 1.0 * exams_use.map { |r| r.score }.sum / exams_use.size
            end

            if a.only_use?
              line[:enrolled_target_use] += 1
            else
              line[:enrolled_target_university] += 1
            end
          end
        end
      end

      if 237075 == item.id
        if polygraf_parsed
          # Второй проход.
          line[:education_type] = EducationType.find(19).id
          line[:education_type_name] = EducationType.find(19).name
          line[:total_places] = 20
          line[:quota_places] = 0
        else
          line[:total_places] = 50
        end

        polygraf_parsed = true unless polygraf_parsed
      end

      # if '42.03.03' == line[:direction].new_code
      #   if 11 == line[:fo].id
      #     if 14 == line[:ff].id
      #       fail '123'
      #     end
      #   end
      # end
      data << line
    end

    # Теперь нужно преобразовать данные и просуммировать цифры по конкурсным
    # группам СПО и т.д. Делаем такую структуру:
    # -> Уровень образования
    #   -> Направление
    #     -> Форма обучения
    #       -> Основа обучения
    @data = {}
    data.each { |l| @data[l[:education_type]] = {} }
    data.each { |l| @data[l[:education_type]][l[:direction].id] = {}}
    data.each { |l| @data[l[:education_type]][l[:direction].id][l[:fo].id] = {}}
    data.each { |l| @data[l[:education_type]][l[:direction].id][l[:fo].id][l[:ff].id] = {}}
    data.each do |l|
      row = @data[l[:education_type]][l[:direction].id][l[:fo].id][l[:ff].id]
      if row.empty?
        row = l
      else
        row[:total_places] += l[:total_places]
        row[:target_places] += l[:target_places]
        row[:quota_places] += l[:quota_places]
        row[:all_applications] += l[:all_applications]
        row[:quota_applications] += l[:quota_applications]
        row[:target_applications] += l[:target_applications]
        row[:after_applications] += l[:after_applications]
        row[:enrolled_all] += l[:enrolled_all]
        row[:enrolled_07_31] += l[:enrolled_07_31]
        row[:enrolled_08_05] += l[:enrolled_08_05]
        row[:enrolled_08_11] += l[:enrolled_08_11]
        row[:enrolled_after] += l[:enrolled_after]
        row[:enrolled_contest_without_100] += l[:enrolled_contest_without_100]
        row[:enrolled_contest_with_100] += l[:enrolled_contest_with_100]
        row[:enrolled_with_quota] += l[:enrolled_with_quota]
        row[:enrolled_with_target] += l[:enrolled_with_target]
        row[:enrolled_with_olymp] += l[:enrolled_with_olymp]
        row[:pass_points] += l[:pass_points]
        row[:pass_points_100] += l[:pass_points_100]
        row[:contest_use] += l[:contest_use]
        row[:contest_use_creative] += l[:contest_use_creative]
        row[:target_use] += l[:target_use]
        row[:quota_use] += l[:quota_use]
      end

      @data[l[:education_type]][l[:direction].id][l[:fo].id][l[:ff].id] = row
    end

    # @data.each do |l|
    #   line = @data[l[:education_type]][l[:direction].id][l[:fo].id][l[:ff].id]
    #
    #   line[:pass_points] = line[:pass_points].min
    #   line[:pass_points_100] = line[:pass_points_100].min
    #   if line[:contest_use].empty?
    #     line[:contest_use] = 0
    #   else
    #     line[:contest_use] = 1.0 * line[:contest_use].sum / line[:contest_use].size
    #   end
    #   if line[:contest_use_creative].empty?
    #     line[:contest_use_creative] = 0
    #   else
    #     line[:contest_use_creative] = 1.0 * line[:contest_use_creative].sum / line[:contest_use_creative].size
    #   end
    #   if line[:target_use].empty?
    #     line[:target_use] = 0
    #   else
    #     line[:target_use] = 1.0 * line[:target_use].sum / line[:target_use].size
    #   end
    #   if line[:quota_use].empty?
    #     line[:quota_use] = 0
    #   else
    #     line[:quota_use] = 1.0 * line[:quota_use].sum / line[:quota_use].size
    #   end
    #
    #   @data[l[:education_type]][l[:direction].id][l[:fo].id][l[:ff].id] = line
    # end

    builder_f1 = Nokogiri::XML::Builder.new do |xml|
      xml.root(id: 415) do
        # Выбираем все бюджетные конкурсные группы обычной приемной кампании.
        index = 1

        @data.each do |level_type, rows1|
          rows1.each do |direction_id, rows2|
            rows2.each do |fo, rows3|
              rows3.each do |ff, line|
                next if line.empty?

                # Всё, кроме аспирантуры.
                next if line[:direction].new_code.split('.')[1] == '06'

                xml.lines(id: index) do
                  xml.oo 415


                  if '29.03.03' == line[:direction].new_code
                    if 19 == line[:education_type]
                      xml.spec 742
                    else
                      xml.spec 92
                    end
                  else
                    xml.spec line[:direction].gzgu
                  end

                  xml.fo case line[:fo].id
                           when 11 then 1
                           when 12 then 2
                           when 10 then 3
                         end
                  xml.ff (14 == line[:ff].id ? 1 : 2)
                  xml.p1_1 line[:total_places]
                  xml.p1_2 line[:quota_places]
                  xml.p1_3 line[:target_places]
                  xml.p2_1 line[:all_applications]
                  xml.p2_2 line[:quota_applications]
                  xml.p2_3 line[:target_applications]
                  xml.p2_4 line[:after_applications]
                  xml.p3_1 line[:enrolled_07_31]
                  xml.p3_2 line[:enrolled_08_05]
                  xml.p3_3 line[:enrolled_08_11]
                  xml.p3_4 0
                  xml.p4_2 line[:enrolled_contest_without_100]
                  xml.p4_3 line[:enrolled_contest_with_100]
                  xml.p4_4 line[:enrolled_with_quota]
                  xml.p4_5 line[:enrolled_with_target]
                  xml.p4_6 0
                  xml.p4_7 0
                  xml.p4_8 line[:enrolled_with_olymp]
                end

                index += 1
              end
            end
          end
        end
      end
    end

    builder_f1a = Nokogiri::XML::Builder.new do |xml|
      xml.root(id: 415) do
        # Выбираем все бюджетные конкурсные группы обычной приемной кампании.
        index = 1

        @data.each do |level_type, rows1|
          rows1.each do |direction_id, rows2|
            rows2.each do |fo, rows3|
              rows3.each do |ff, line|
                next if line.empty?

                # Всё, кроме аспирантуры.
                next unless line[:direction].new_code.split('.')[1] == '06'

                xml.lines(id: index) do
                  xml.oo 415


                  if '29.03.03' == line[:direction].new_code
                    if 19 == line[:education_type]
                      xml.spec 742
                    else
                      xml.spec 92
                    end
                  else
                    xml.spec line[:direction].gzgu
                  end

                  xml.fo case line[:fo].id
                           when 11 then 1
                           when 12 then 2
                           when 10 then 3
                         end
                  xml.ff (14 == line[:ff].id ? 1 : 2)
                  xml.p1_1 line[:total_places]
                  xml.p1_2 0
                  xml.p2_1 line[:all_applications]
                  xml.p2_2 0
                  xml.p3_1 line[:enrolled_all]
                  xml.p3_2 0
                  xml.p4 0
                end

                index += 1
              end
            end
          end
        end
      end
    end

    builder_f2 = Nokogiri::XML::Builder.new do |xml|
      xml.root(id: 415) do
        # Выбираем все бюджетные конкурсные группы обычной приемной кампании.
        index = 1

        @data.each do |level_type, rows1|
          rows1.each do |direction_id, rows2|
            rows2.each do |fo, rows3|
              rows3.each do |ff, line|
                next if line.empty?

                # Всё, кроме аспирантуры.
                next if line[:direction].new_code.split('.')[1] == '06'

                xml.lines(id: index) do
                  xml.oo 415


                  if '29.03.03' == line[:direction].new_code
                    if 19 == line[:education_type]
                      xml.spec 742
                    else
                      xml.spec 92
                    end
                  else
                    xml.spec line[:direction].gzgu
                  end

                  xml.fo case line[:fo].id
                           when 11 then 1
                           when 12 then 2
                           when 10 then 3
                         end
                  xml.ff (14 == line[:ff].id ? 1 : 2)
                  xml.p1_1 line[:enrolled_all]
                  xml.p2_1 line[:enrolled_contest]
                  xml.p2_2 line[:enrolled_contest_use]
                  xml.p2_3 0
                  xml.p2_4 line[:enrolled_contest_university]
                  xml.p2_5 line[:enrolled_contest_creative]
                  xml.p3_1 line[:enrolled_target_use]
                  xml.p3_2 line[:enrolled_target_university]
                  xml.p4_1 line[:enrolled_quota_use]
                  xml.p4_2 line[:enrolled_quota_university]
                  xml.p5 line[:enrolled_with_olymp]
                  xml.p6_1 line[:contest_use].empty? ? 0 : 1.0 * line[:contest_use].sum / line[:contest_use].size
                  xml.p6_2 0
                  xml.p6_3 line[:contest_use_creative].empty? ? 0 : 1.0 * line[:contest_use_creative].sum / line[:contest_use_creative].size
                  xml.p6_4 0
                  xml.p7_1 line[:target_use].empty? ? 0 : 1.0 * line[:target_use].sum / line[:target_use].size
                  xml.p7_2 line[:quota_use].empty? ? 0 : 1.0 * line[:quota_use].sum / line[:quota_use].size
                  xml.p8 line[:pass_points_100].min
                end

                index += 1
              end
            end
          end
        end
      end
    end

    respond_to do |format|
      format.xlsx
      format.xml { render xml: builder_f2.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip }
    end
  end

  # Форма №1. Сведения о приеме граждан на обучение по программам бакалавриата,
  # специалитета и магистратуры на места за счет федерального бюджета (приказ
  # Минобрнауки России от 30 января 2013 г. № 1424), бюджетов субъектов
  # Российской Федерации, местных бюджетов и по договорам об оказании платных
  # образовательных услуг
  def mon_pk_f1_2014_06_23
    @data = []
    Entrance::Campaign.find(2014).items.find_all { |i| !i.payed? }.sort_by { |i| "#{i.direction.name} #{i.direction.new_code}" }.each do |item|
      next if item.direction.new_code.split('.')[1] == '06'
      next if [244350,237078,244351].include?(item.id)

      line = {
        oo: 415,
        spec: item.direction,
        ff: (item.payed? ? 2 : 1)
      }
      line[:fo] = case item.form
                  when 11 then 1
                  when 12 then 2
                  when 10 then 3
                  end

      field_payment = item.payed? ? 'paid' : 'budget'
      field_form = case item.form
                     when 11 then 'o'
                     when 12 then 'oz'
                     when 10 then 'z'
                   end

      line[:total_places] = item.send("number_#{field_payment}_#{field_form}")
      line[:total_places] += item.send("number_quota_#{field_form}")
      line[:target_places] = 0
      item.competitive_group.target_organizations.each do |org|
        org.items.where(direction_id: item.direction_id, education_level_id: item.education_level_id).each do |i|
          line[:total_places] += i.send("number_target_#{field_form}")
          line[:target_places] += i.send("number_target_#{field_form}")
        end
      end
      line[:quota_places] = item.number_quota_o

      line[:all_applications] = 0
      line[:quota_applications] = 0
      line[:target_applications] = 0
      line[:after_applications] = 0
      line[:enrolled_07_31] = 0
      line[:enrolled_08_05] = 0
      line[:enrolled_08_11] = 0
      line[:enrolled_after] = 0

      line[:enrolled_without] = 0
      line[:enrolled_with_100] = 0
      line[:enrolled_with_quota] = 0
      line[:enrolled_with_target] = 0
      line[:enrolled_with_olymp] = 0
      item.applications.each do |a|
        if [4,6,8].include?(a.status_id)
          line[:all_applications] += 1
          line[:quota_applications] += 1 if a.benefits.first && 4 == a.benefits.first.benefit_kind_id
          line[:target_applications] += 1 unless a.competitive_group_target_item_id.nil?
        end

        if 8 == a.status_id && a.order_id
          case (a.order.order_signing || a.order.order_editing).to_date
            when Date.new(2014, 7, 31) then line[:enrolled_07_31] += 1
            when Date.new(2014, 8, 5) then line[:enrolled_08_05] += 1
            when Date.new(2014, 8, 11) then line[:enrolled_08_11] += 1
            else line[:enrolled_after] += 1
          end

          line[:enrolled_without] += 1
          if a.benefits.first
            if [1,3].include?(a.benefits.first.benefit_kind_id)
              line[:enrolled_without] -= 1
            end

            case a.benefits.first.benefit_kind_id
              when 1 then line[:enrolled_with_olymp] += 1
              when 3 then line[:enrolled_with_100] += 1
              when 4 then line[:enrolled_with_quota] += 1
            end
          end

          line[:enrolled_with_target] += 1 unless a.competitive_group_target_item_id.nil?
        end
      end

      @data << line
    end

    # builder = Nokogiri::XML::Builder.new do |xml|
    #   xml.root(id: 415) do
    #     # Выбираем все бюджетные конкурсные группы обычной приемной кампании.
    #     index = 1
    #     Entrance::Campaign.find(2014).items.find_all { |i| !i.payed? }.sort_by { |i| "#{i.direction.name} #{i.direction.new_code}" }.each do |item|
    #       next if item.direction.new_code.split('.')[1] == '06'
    #
    #       next if [244350,237078,244351].include?(item.id)
    #
    #       xml.lines(id: index) do
    #         mon_pk_f1_2014_06_23_line(xml, item)
    #       end
    #
    #       index += 1
    #     end
    #   end
    # end

    respond_to do |format|
      # format.xml { render xml: builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip }
      format.xml { render xml: @data.to_xml }
      format.xlsx
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