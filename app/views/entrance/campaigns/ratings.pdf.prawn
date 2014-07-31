prawn_document margin: [72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54],
               page_layout: :landscape do |pdf|
  @campaign.competitive_groups.select { |g| g.id == 192669 }.each do |competitive_group|
    # next if competitive_group.items.first.payed?

    if competitive_group.items.first.applications.for_rating.to_a.size > 0
      render partial: 'ratings_list', locals: { pdf: pdf,
                                                group: competitive_group }

      pdf.start_new_page
    end
  end
end