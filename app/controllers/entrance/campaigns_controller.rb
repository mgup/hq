class Entrance::CampaignsController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:applications, :balls, :rating, :crimea_rating]

  # skip_before_action :authenticate_user!, only: [:applications, :balls, :stats]
  skip_before_action :authenticate_user!, only: [:applications, :balls, :stats]

  load_and_authorize_resource class: 'Entrance::Campaign', except: [:results, :report, :stats]
  load_resource class: 'Entrance::Campaign', only: [:results, :competitive_groups]

  #before_action :validate_crimea, only: [:rating]

  before_action :initialize_default_filters, only: [:dashboard, :crimea_rating, :rating]

  def format_html?
    request.format.html?
  end

  def choice

  end

  def validate_crimea
    @campaign = Entrance::Campaign.find(32015) unless signed_in?
  end

  # Пофамильные списки поступающих (рейтинги).
  def rating
    authorize! :manage, Entrance::Entrant

    if user_signed_in?
      @items = Entrance::CompetitiveGroupItem.find(@applications.collect{ |app| app.competitive_group_item_id }.uniq)
    else
      if @competitive_group.name.include?('Крым')
        @items = Entrance::CompetitiveGroupItem.find(@applications.collect{ |app| app.competitive_group_item_id }.uniq)
      else
        @applications = []
        render 'entrance/campaigns/rating_hidden'
      end
    end
  end

  def crimea_rating
    items = Entrance::CompetitiveGroupItem.find(@applications.collect{ |app| app.competitive_group_item_id }.uniq)
    if @applications.take
      @number = items.collect { |i| i.total_number }.sum
    end
  end

  def applications
    params[:direction] ||= 1887

    @applications = applications_from_filters.actual

    if current_user && current_user.is?(:selection_io)
      @applications = @applications.ioo_see
    end

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def orders
    @orders = Office::Order.entrance.from_year_and_month(2015, 6)
  end

  def numbers

  end

  def print_all
    @department = Department.find(params[:department]) if params[:department]
    @for_aspirants = true if params[:aspirants]
    respond_to do |format|
      format.pdf
    end
  end

  def print_department_register
    @department = Department.find(params[:department])
    @apps = @campaign.applications.actual.where('DATE(entrance_applications.created_at) = ?',
                 Date.strptime(params[:date], '%d.%m.%Y')).from_faculty(params[:department])

    respond_to do |format|
      format.pdf
    end
  end

  def results
    authorize! :manage, Entrance::Exam

    if params[:exam]
      found = false
      @campaign.exams.each do |exam|
        found = true if exam.id == params[:exam].to_i
      end
      params[:exam] = @campaign.exams.first.id unless found
    else
      params[:exam] ||= @campaign.exams.first.id
    end

    @exam = Entrance::Exam.find(params[:exam])
    @entrants = Entrance::Entrant.from_exam(params[:exam])
      .order(:last_name, :first_name, :patronym)

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def balls
    if params[:exam]
      found = false
      @campaign.exams.each do |exam|
        found = true if exam.id == params[:exam].to_i
      end
      if @campaign.exams.any?
        params[:exam] = @campaign.exams.first.id unless found
      end
    else
      params[:exam] ||= @campaign.exams.first.id
    end

    @exam = Entrance::Exam.find(params[:exam])
    @entrants = Entrance::Entrant.from_exam(params[:exam]).
      order(:last_name, :first_name, :patronym).includes(:exam_results)
  end

  def competitive_groups
    @items = @campaign.items.group_by {|i| i.direction}
  end

  def stats
    @directions = Entrance::Campaign.where(start_year: Entrance::Campaign::CURRENT_YEAR).
      map(&:competitive_groups).sum.map(&:items).sum.map(&:direction).uniq.sort_by do |d|
      [d.bachelor? || d.specialist? ? 1 : 2, d.master? ? 1 : 2, d.name]
    end

    fields = {
      budget: [:o_o, :o_quota, :o_target, :o_crimea, :oz_o],
      paid: [:po_o, :po_crimea, :po_foreign, :poz_o, :poz_foreign, :pz_o]
    }

    @data = {}
    @directions.each do |direction|
      @data[direction.description] = {}

      fields[:budget].each do |group|
        @data[direction.description][group] = {
          applications: [],
          total: 0,
          originals: 0,
          places: 0,
          enrolled: 0,
          contest: 0,
          contest_by_original: 0
        }
      end

      fields[:paid].each do |group|
        @data[direction.description][group] = {
          applications: [],
          total: 0,
          contracts: 0,
          places: 0,
          enrolled: 0,
          contest: 0
        }
      end
    end

    @directions.each do |direction|
      o_o = 0
      o_quota = 0
      o_target = 0
      o_crimea = 0
      oz_o = 0
      po_o = 0
      po_crimea = 0
      po_foreign = 0
      poz_o = 0
      poz_foreign = 0
      pz_o = 0

      direction.competitive_group_items.each do |gi|
        g = gi.competitive_group

        next unless [12016, 22016, 32016].include?(g.campaign.id)

        if g.name.include?(', бюджет')
          if g.name.include?('Крым')
            o_crimea += gi.number_budget_o
            # o_o += gi.number_budget_o
          else
            if g.target_organizations.any?
              o_target += g.target_organizations.map(&:items).sum.find_all { |i| i.direction.description == direction.description }.map(&:number_target_o).sum
            end

            o_o += gi.number_budget_o
            o_quota += gi.number_quota_o
            oz_o += gi.number_budget_oz
          end
        else
          if g.name.include?('Крым')
            po_crimea += gi.number_paid_o
          elsif g.name.include?('иностранцы')
            po_foreign += gi.number_paid_o
            poz_foreign += gi.number_paid_oz
          else
            po_o += gi.number_paid_o
            poz_o += gi.number_paid_oz
            pz_o += gi.number_paid_z
          end
        end
      end

      @data[direction.description][:o_o][:places] = o_o
      @data[direction.description][:o_quota][:places] = o_quota
      @data[direction.description][:o_target][:places] = o_target
      @data[direction.description][:o_crimea][:places] = o_crimea
      @data[direction.description][:oz_o][:places] = oz_o
      @data[direction.description][:po_o][:places] = po_o
      @data[direction.description][:po_crimea][:places] = po_crimea
      @data[direction.description][:po_foreign][:places] = po_foreign
      @data[direction.description][:poz_o][:places] = poz_o
      @data[direction.description][:poz_foreign][:places] = poz_foreign
      @data[direction.description][:pz_o][:places] = pz_o
    end

    Entrance::Application.where(campaign_id: [12016, 22016, 32016], status_id: [4, 5, 7, 8]).all.each do |application|
      if application.payed?
        # Внебюджет
        if 10 == application.form
          @data[application.direction.description][:pz_o][:applications] << application
        elsif 12 == application.form
          if application.competitive_group.name.include?('иностранцы')
            @data[application.direction.description][:poz_foreign][:applications] << application
          else
            @data[application.direction.description][:poz_o][:applications] << application
          end
        else
          if application.competitive_group.name.include?('иностранцы')
            @data[application.direction.description][:po_foreign][:applications] << application
          elsif application.competitive_group.name.include?('Крым')
            @data[application.direction.description][:po_crimea][:applications] << application
          else
            @data[application.direction.description][:po_o][:applications] << application
          end
        end
      else
        # Бюджет
        if 12 == application.form
          @data[application.direction.description][:oz_o][:applications] << application
        elsif application.competitive_group.name.include?('Крым')
          @data[application.direction.description][:o_crimea][:applications] << application
        elsif application.competitive_group.name.include?('иностранцы')
          @data[application.direction.description][:o_foreign][:applications] << application
        elsif application.competitive_group_target_item
          @data[application.direction.description][:o_target][:applications] << application
        elsif application.benefits.any? && application.benefits.first.benefit_kind.special_rights?
          @data[application.direction.description][:o_quota][:applications] << application
        else
          @data[application.direction.description][:o_o][:applications] << application
        end
      end
    end

    @directions.each do |direction|
      fields[:budget].each do |group|
        apps = @data[direction.description][group][:applications]

        @data[direction.description][group][:total] = apps.size
        @data[direction.description][group][:originals] = apps.find_all { |a| [4,8].include?(a.status_id) && a.original? }.size
        @data[direction.description][group][:enrolled] = apps.find_all { |a| 8 == a.status_id }.size
        @data[direction.description][group][:contest] =
          (1.0 * @data[direction.description][group][:total] / @data[direction.description][group][:places]).round(2) if @data[direction.description][group][:places] > 0
        @data[direction.description][group][:contest_by_original] =
          @data[direction.description][group][:originals] / @data[direction.description][group][:places] if @data[direction.description][group][:places] > 0
      end

      fields[:paid].each do |group|
        apps = @data[direction.description][group][:applications]

        @data[direction.description][group][:total] = apps.size
        @data[direction.description][group][:contracts] = apps.find_all { |a| a.contract.present? }.size
        @data[direction.description][group][:enrolled] = apps.find_all { |a| 8 == a.status_id }.size
        @data[direction.description][group][:contest] =
          (1.0 * @data[direction.description][group][:total] / @data[direction.description][group][:places]).round(2) if @data[direction.description][group][:places] > 0
      end
    end
  end

  def report
    #.
      # find_all { |a| [11, 12].include?(a.form) && !a.payed? && %w(03 05).include?(a.direction.new_code.split('.')[1]) && 32014 != a.campaign.id }

    respond_to do |format|
      format.html do
        @campaign_year = Entrance::Campaign::CURRENT_YEAR

        @applications = []

        competitive_group_titles = { o: {}, oz: {}, z: {} }

        # Entrance::Campaign.where(start_year: @campaign_year).each do |campaign|
        Entrance::Campaign.where(id: [12016, 22016, 32016]).each do |campaign|
          @applications += campaign.applications.includes(competitive_group_item: :direction).actual#.first(100)
          campaign.competitive_groups.each do |competitive_group|
            next if competitive_group.items.empty?

            title = "#{competitive_group.items.first.direction.new_code} #{competitive_group.name}"
            if competitive_group.items.first.total_budget_o > 0 || competitive_group.items.first.total_paid_o > 0
              competitive_group_titles[:o][title] = competitive_group.items.first
            end
            if competitive_group.items.first.total_budget_oz > 0 || competitive_group.items.first.total_paid_oz > 0
              competitive_group_titles[:oz][title] = competitive_group.items.first
            end
            if competitive_group.items.first.total_budget_z > 0 || competitive_group.items.first.total_paid_z > 0
              competitive_group_titles[:z][title] = competitive_group.items.first
            end
          end
        end

        by_competitive_group = @applications.group_by do |a|
          # a.competitive_group
          title = "#{a.competitive_group.items.first.direction.new_code} #{a.competitive_group.name}"

          # case a.education_form_id
          # when 11
          #   competitive_group_titles[:o][title] = a.competitive_group.items.first
          # when 12
          #   competitive_group_titles[:o][title] = a.competitive_group.items.first
          # when 10
          #   competitive_group_titles[:z][title] = a.competitive_group.items.first
          # else
          #   fail 'Неизвестная форма обучения.'
          # end

          title
        end

        data_draft = []
        by_competitive_group.each do |competitive_group_title, applications|
          d = [
            competitive_group_title,
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0]
          ]

          if competitive_group_titles[:o][competitive_group_title]
            competitive_group_item = competitive_group_titles[:o][competitive_group_title]
            d[1][2] = competitive_group_item.total_budget_o
            competitive_group_item.competitive_group.target_organizations.each do |org|
              org.items.where(direction_id: competitive_group_item.direction_id, education_level_id: competitive_group_item.education_type_id).each do |i|
                d[1][2] += i.send("number_target_o")
              end
            end

            d[3][2] = competitive_group_item.total_paid_o
          end

          if competitive_group_titles[:oz][competitive_group_title]
            competitive_group_item = competitive_group_titles[:oz][competitive_group_title]
            d[2][2] = competitive_group_item.total_budget_oz
            d[4][2] = competitive_group_item.total_paid_oz
          end

          if competitive_group_titles[:z][competitive_group_title]
            competitive_group_item = competitive_group_titles[:z][competitive_group_title]
            d[5][2] = competitive_group_item.total_paid_z
          end

          applications.each do |application|
            if application.is_payed
              case application.education_form_id
              when 11
                d[3][0] += 1
                d[3][1] += 1 if application.contract
                d[3][3] += 1 if application.order_id
              when 12
                d[4][0] += 1
                d[4][1] += 1 if application.contract
                d[4][3] += 1 if application.order_id
              when 10
                d[5][0] += 1
                d[5][1] += 1 if application.contract
                d[5][3] += 1 if application.order_id
              else
                fail 'Неизвестная форма обучения.'
              end
            else
              case application.education_form_id
              when 11
                d[1][0] += 1
                d[1][1] += 1 if application.original?
                d[1][3] += 1 if application.order_id
              when 12
                d[2][0] += 1
                d[2][1] += 1 if application.original?
                d[2][3] += 1 if application.order_id
              end
            end
          end

          data_draft << d
        end

        data_draft.each do |row|
          if row[1][2] > 0
            row[1][4] = (1.0 * row[1][0] / row[1][2]).round(2)
            row[1][5] = (1.0 * row[1][1] / row[1][2]).round(2)
          end
          if row[2][2] > 0
            row[2][4] = (1.0 * row[2][0] / row[2][2]).round(2)
            row[2][5] = (1.0 * row[2][1] / row[2][2]).round(2)
          end
          if row[3][2] > 0
            row[3][4] = (1.0 * row[3][0] / row[3][2]).round(2)
            row[3][5] = (1.0 * row[3][1] / row[3][2]).round(2)
          end
          if row[4][2] > 0
            row[4][4] = (1.0 * row[4][0] / row[4][2]).round(2)
            row[4][5] = (1.0 * row[4][1] / row[4][2]).round(2)
          end
          if row[5][2] > 0
            row[5][4] = (1.0 * row[5][0] / row[5][2]).round(2)
            row[5][5] = (1.0 * row[5][1] / row[5][2]).round(2)
          end
        end

        @data = data_draft.sort_by do |row|
          parts = row[0].split('.')
          [parts[2][3..(parts[2].rindex('(')||(parts[2].rindex('К'))||(parts[2].size+1))-2], parts[0], parts[1], parts[2][3..-1]]
        end

        last_row = [
          'По всем конкурсным группам',
          [@data.map(&:second).map(&:first).sum, @data.map(&:second).map(&:second).sum, @data.map(&:second).map(&:third).sum, @data.map(&:second).map(&:fourth).sum, 0, 0],
          [@data.map(&:third).map(&:first).sum, @data.map(&:third).map(&:second).sum, @data.map(&:third).map(&:third).sum, @data.map(&:third).map(&:fourth).sum, 0, 0],
          [@data.map(&:fourth).map(&:first).sum, @data.map(&:fourth).map(&:second).sum, @data.map(&:fourth).map(&:third).sum, @data.map(&:fourth).map(&:fourth).sum, 0, 0],
          [@data.map(&:fifth).map(&:first).sum, @data.map(&:fifth).map(&:second).sum, @data.map(&:fifth).map(&:third).sum, @data.map(&:fifth).map(&:fourth).sum, 0, 0],
          [@data.map{|x| x[5]}.map(&:first).sum, @data.map{|x| x[5]}.map(&:second).sum, @data.map{|x| x[5]}.map(&:third).sum, @data.map{|x| x[5]}.map(&:fourth).sum, 0, 0]
        ]

        if last_row[1][2] > 0
          last_row[1][4] = (1.0 * last_row[1][0] / last_row[1][2]).round(2)
          last_row[1][5] = (1.0 * last_row[1][1] / last_row[1][2]).round(2)
        end
        if last_row[2][2] > 0
          last_row[2][4] = (1.0 * last_row[2][0] / last_row[2][2]).round(2)
          last_row[2][5] = (1.0 * last_row[2][1] / last_row[2][2]).round(2)
        end
        if last_row[3][2] > 0
          last_row[3][4] = (1.0 * last_row[3][0] / last_row[3][2]).round(2)
          last_row[3][5] = (1.0 * last_row[3][1] / last_row[3][2]).round(2)
        end
        if last_row[4][2] > 0
          last_row[4][4] = (1.0 * last_row[4][0] / last_row[4][2]).round(2)
          last_row[4][5] = (1.0 * last_row[4][1] / last_row[4][2]).round(2)
        end
        if last_row[5][2] > 0
          last_row[5][4] = (1.0 * last_row[5][0] / last_row[5][2]).round(2)
          last_row[5][5] = (1.0 * last_row[5][1] / last_row[5][2]).round(2)
        end

        @data << last_row


      end
      # format.xlsx do
      #   response.headers['Content-Disposition'] = 'attachment; filename="' +
      #     "Количество поданных заявлений на #{l Time.now}.xlsx" + '"'
      # end
      format.xml do
        @applications = Entrance::Application.
          where(campaign_id: [12016, 22016, 32016, 42016],
                status_id: [4, 5, 6, 8],
                is_payed: 1).
          #where(number: [
          #  "16-СД001","16-ИД001","16-ЭМ001","16-ПД003","16-НД003","16-СД003","16-ГД004","16-ДД011","16-ЖД005","16-СД004",
          #  "16-ЖД011","16-ЖД014","16-СД005","16-СД006","16-ЖД018","16-СД010","16-ЖД026","16-СД011","16-ИД008","16-ЖД037",
          #  "16-АД006","16-СД017","16-ДД052","16-НД008","16-ЖД074","16-ДД073","16-ДД084","16-ДД085","16-СД025","16-ДД108",
          #  "16-ДД110","16-ПД018","16-ПД019","16-ПД020","16-СД034","16-СД036","16-АД024","16-СД038","16-ДД135","16-ДД136",
          #  "16-ПД023","16-ПД026","16-ИД041","16-ТД014","16-ПД028","16-ИД045","16-СД050","16-ЖД291","16-РМ011","16-ПМ010",
          #  "16-ПД032","16-ДД180","16-СД054","16-ДД187","16-ГД153","16-ДД197","16-ИД056","16-ПД033","16-НД021","16-СД061",
          #  "16-АМ003","16-ПД035","16-ЖД350","16-ЖД356","16-ПД037","16-СД067","16-СД072","16-ДД235","16-СД073","16-СД074",
          #  "16-ИД072","16-ПД041","16-КД020","16-ПД043","16-ЖД403","16-АД060","16-СД086","16-АД067","16-ДД274","16-СД091",
          #  "16-ЖД431","16-СД093","16-ДД280","16-АД070","16-СД095","16-ГД205","16-ПД046","16-СД097","16-СД098","16-СД099",
          #  "16-СД100","16-СД101","16-ДД319","16-КД031","16-СД105","16-ЖД483","16-ДД336","16-ЖД505","16-СД110","16-ЖД517",
          #  "16-ИД107","16-СД114","16-СД115","16-ГД248","16-СД119","16-ДД354","16-СД123","16-ГД262","16-ПД062","16-ПД064",
          #  "16-НД051","16-ДД390","16-СД132","16-ИД127","16-ЖД573","16-СД136","16-ДД397","16-СД138","16-СД139","16-ИД134",
          #  "16-ДД403","16-ДД405","16-ПД070","16-ПД071","16-ЖД605","16-КМ013","16-ЖД607","16-НД057","16-ДД414","16-ИД140",
          #  "16-КД050","16-ПД074","16-ПД075","16-ПД076","16-КД052","16-КД053","16-ПД079","16-НД066","16-НД067","16-ПД083",
          #  "16-ПД084","16-ПД085","16-ПД087","16-ТД040","16-ДД421","16-ПД088","16-ПД089","16-ПД090","16-КД061","16-ПД092",
          #  "16-ПД094","16-ПД095","16-НД071","16-ТД043","16-ПД101","16-ПД102","16-ПД103","16-ПД104","16-ДД428","16-ПД105",
          #  "16-КД072","16-ПД107","16-ПД109","16-НД077","16-ПД111","16-НД078","16-ПД114","16-СД162","16-ПД119","16-ТД055",
          #  "16-ИД153","16-ДД441","16-ПД120","16-КД083","16-ПД123","16-ДД445","16-ПД124","16-ПД126","16-СД169","16-ПД129",
          #  "16-ПД130","16-КД091","16-ПД132","16-ТД060","16-НД094","16-ТД061","16-ДД446","16-НД097","16-НД098","16-НД100",
          #  "16-НД102","16-ДД448","16-НД103","16-ПД145","16-ПД146","16-ПД147","16-ТД065","16-ТД066","16-НД110","16-ПД151",
          #  "16-ПД152","16-ТД069","16-ПД154","16-НД115","16-НД116","16-ТД071","16-ТД072","16-НД119","16-ПД161","16-ТД073",
          #  "16-ИД162","16-ПД162","16-НД124","16-ПД165","16-ПД167","16-ПД170","16-ПД172","16-НД136","16-НД138","16-ТД090",
          #  "16-ПД178","16-СД180","16-ДД463","16-ИД167","16-СД186","16-СД187","16-АД135","16-ИД180","16-ДД475","16-ДД477",
          #  "16-ИД182","16-ИД183","16-ИД186","16-ИД187","16-ПД189","16-СД205","16-НД151","16-АД149","16-РМ054","16-ИД199",
          #  "16-СД217","16-СД218","16-ДД485","16-ЭМ033","16-ЭМ034","16-АД163","16-СД232","16-РМ064","16-СД238","16-РМ067",
          #  "16-ИД226","16-СД243","16-АД177","16-ДМ040","16-РМ072","16-ИД236","16-СД252","16-ЖМ020","16-ЖМ021","16-СД257",
          #  "16-ТМ014","16-АД187","16-СД268","16-СД271","16-СД277","16-СД281","16-АД201","16-СД287","16-СД289","16-ЖМ033",
          #  "16-СД294","16-ИД282","16-СД297","16-АД220","16-ДД539","16-СД308","16-ИД299","16-ДМ058","16-ДМ059","16-ДМ071",
          #  "16-ПМ037","16-ЭД272","16-НМ023","16-ДМ095","16-ДМ101","16-ДМ110","16-АД237","16-РД173"           
          #]).
          # where(campaign_id: [12016],
          #       status_id: [8],
          #       is_payed: 0).
          find_all { |a| a.pass_min_score? }

        doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.PackageData do
            xml.Applications do
              @applications.each do |application|
                # xml << application.to_fis.xpath('/Application').to_xml.to_str
              end

              # @applications.find_all { |a| a.order.blank? || a.order.signing_date.blank? }.each do |application|
              #   xml << application.to_fis.xpath('/Application').to_xml.to_str
              # end
            end

            xml.Orders do
              apps = @applications.find_all { |a| 8 == a.status_id && a.order.signing_date.present? }
              # apps = []

              xml.OrdersOfAdmission do
                apps.group_by { |a| a.order }.each do |o, applications|
                  a = applications[0]

                  xml.OrderOfAdmission do
                    xml.OrderOfAdmissionUID "order_of_admission_#{o.id}"
                    xml.CampaignUID a.campaign.id
                    xml.OrderName a.competitive_group.name
                    xml.OrderNumber o.number
                    xml.OrderDate o.signing_date.to_date.iso8601

                    xml.EducationFormID a.education_form_id
                    xml.EducationLevelID a.competitive_group_item.education_type_id
                    if !a.is_payed && a.benefits.any? && a.order.signing_date == Date.new(2015, 7, 30)
                      xml.FinanceSourceID 20
                    else
                      xml.FinanceSourceID a.is_payed ? 15 : (a.competitive_group_target_item_id.nil? ? 14 : 16)
                    end

                    if !a.is_payed?
                      if a.benefits.any?
                        xml.Stage 0
                      elsif a.order.present? && Date.new(2016, 8, 3) == a.order.signing_date
                        xml.Stage 1
                      else
                        xml.Stage 2
                      end
                    end
                  end
                end
              end

              xml.Applications do
                apps.each do |application|
                  xml.Application do
                    xml.ApplicationUID application.id
                    xml.OrderUID "order_of_admission_#{application.order.id}"
                    xml.OrderTypeID 1

                    if application.benefits.any? && application.benefits.first.olympic_document
                      # Олимпиады.
                      xml.CompetitiveGroupUID  application.competitive_group.fis_uid
                    elsif application.benefits.any?
                      # Квота особых прав
                      xml.CompetitiveGroupUID  "#{application.competitive_group.fis_uid}_quota"
                    elsif application.competitive_group.name.include?('Крым')
                      # Квота Крым
                      xml.CompetitiveGroupUID  application.competitive_group.fis_uid
                    elsif application.competitive_group_target_item_id.present?
                      # Квота целевого приема
                      xml.CompetitiveGroupUID  "#{application.competitive_group.fis_uid}_target"
                      # xml.TargetOrganizationUID application.competitive_group_target_item.target_organization.id
                    else
                      xml.CompetitiveGroupUID  application.competitive_group.fis_uid
                    end

                    if !application.is_payed?
                      xml.OrderIdLevelBudget 1
                    end
                  end
                end
              end
            end
          end
        end

        render xml: doc.to_xml
      end
    end
  end

  def register
    if params[:date] == ''
      # if params[:faculty] == ''
#         @applications = applications_from_filters
#       else
#         @applications = applications_from_filters(faculty: true)
#       end
      @applications = applications_from_filters
    else
      # if params[:faculty] == ''
#         @applications = applications_from_filters(date: true)
#       else
#         @applications = applications_from_filters(date: true, faculty: true)
#       end
      @applications = applications_from_filters(date: true)
    end

    # if params[:faculty] == ''
#       @directions = Direction.for_campaign(@campaign)
#     else
#       @directions = Direction.for_campaign(@campaign).from_faculty(params[:faculty])
#     end

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def temp_print_all_checks
    params[:faculty] ||= 3 # 5,6,7
    @faculty = Department.find(params[:faculty])

    checks_all = Entrance::UseCheck.all.joins(:entrant).
      joins('LEFT JOIN entrance_applications AS a ON a.entrant_id = entrance_entrants.id').
      where('a.campaign_id = 2015').
      where('a.packed = 1').
      joins('LEFT JOIN competitive_group_items as i ON a.competitive_group_item_id = i.id').
      joins('LEFT JOIN directions AS d ON d.id = i.direction_id').
      where('d.department_id = ?', params[:faculty])

    grouped = checks_all.group_by { |c| c.entrant }

    @checks = []
    grouped.each do |_, checks|
      @checks << checks.sort_by { |c| c.date }.last
    end

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def paid_enrollment
    render_report Entrance::PaidEnrollmentReport.new(Entrance::Campaign::CURRENT_YEAR)
  end

  # Конфликты при проверке ЕГЭ.
  def conflicts

  end

  # Пофамильные списки поступающих с баллами.
  def ratings
    respond_to do |format|
      format.pdf
    end
  end

  def protocol_permit
    @directions = @campaign.competitive_groups.map(&:items).sum.map(&:direction).uniq.sort_by do |d|
      [d.bachelor? || d.specialist? ? 1 : 2, d.master? ? 1 : 2, d.name]
    end
    respond_to do |format|
      format.pdf
    end
  end

  private

  # Инициализация фильтров по-умолчанию.
  def initialize_default_filters
    if params[:competitive_group]
      unless @campaign.competitive_groups.map { |g| g.id }.include?(params[:competitive_group].to_i)
        params[:competitive_group] = @campaign.competitive_groups.first.id
      end
    else
      # params[:competitive_group] = @campaign.competitive_groups.first.id
      params[:competitive_group] = 516467
    end

    if params[:competitive_group]
      @competitive_group = Entrance::CompetitiveGroup.find(params[:competitive_group])

      @direction = @competitive_group.items.first.direction
      params[:direction] = @direction.id
    else
      params[:direction] ||= 1887
      @direction = Direction.find(params[:direction])
    end

    params[:form] ||= 11
    @form = EducationForm.find(params[:form])

    params[:payment] ||= 14
    @source = EducationSource.find(params[:payment])

    if params[:competitive_group]

      @applications = @competitive_group.items.first.applications.for_rating.rating(params[:form],
                                                               params[:payment],
                                                               params[:direction])
    else
      @applications = @campaign.applications.for_rating.rating(params[:form],
                                                               params[:payment],
                                                               params[:direction])
    end
  end

  def applications_from_filters(opts = { form: true, payment: true, date: false, faculty: false })
    params[:date] ||= l(Date.today)

    params[:form]      ||= 11
    @form = EducationForm.find(params[:form])

    params[:payment]   ||= 14
    @source = EducationSource.find(params[:payment])

    form_method = case params[:form]
                  when '10'
                    :z_form
                  when '12'
                    :oz_form
                  else
                    :o_form
                  end

    payment_method = case params[:payment]
                     when '15'
                       :paid
                     else
                       :not_paid
                     end

    apps = @campaign.applications.actual
      .joins(competitive_group_item: :direction)
      .joins('LEFT JOIN entrance_benefits ON entrance_benefits.application_id = entrance_applications.id')
      .send(form_method).send(payment_method).order('entrance_applications.created_at')
    # .order('(entrance_benefits.benefit_kind_id = 1) DESC, entrance_applications.number ASC')

    apps = apps.send(form_method) if opts[:form]
    apps = apps.send(payment_method) if opts[:payment]

    if opts[:date]
      apps = apps.where('DATE(entrance_applications.created_at) = ?',
                 Date.strptime(params[:date], '%d.%m.%Y'))
    end

    if opts[:faculty]
      apps = apps.from_faculty(params[:faculty])
    end

    if params[:direction].present?
      @direction = Direction.find(params[:direction])
      apps = apps.where('directions.id = ?', params[:direction])
    end

    apps
  end
end
