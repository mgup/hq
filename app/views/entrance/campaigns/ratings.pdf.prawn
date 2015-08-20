prawn_document margin: [72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54],
               page_layout: :landscape do |pdf|
  @campaign.competitive_groups.each do |competitive_group|
    # next if competitive_group.items.first.payed?
    #
    # next unless [336159,336153].include?(competitive_group.id)

    # next unless [372995].include?(competitive_group.id)

    # next if 6 == competitive_group.items.first.direction.department_id
    # next if 7 == competitive_group.items.first.direction.department_id
    #
    # if 5 == competitive_group.items.first.direction.department_id
    #   next unless 193640 == competitive_group.id
    # end
    # next unless 3 == competitive_group.items.first.direction.department_id

    # next unless competitive_group.items.first.direction.master?

    if competitive_group.items.first.applications.for_rating.to_a.size > 0
      render partial: 'ratings_list', locals: { pdf: pdf,
                                                group: competitive_group }

      # pdf.start_new_page
    end
  end
end
