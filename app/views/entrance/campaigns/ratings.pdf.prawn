prawn_document page_layout: :landscape do |pdf|
  @campaign.competitive_groups.select { |g| 193585 == g.id }.each do |competitive_group|
    next if competitive_group.items.first.payed?

    render partial: 'ratings_list', locals: { pdf: pdf,
                                              group: competitive_group }

    pdf.start_new_page
  end
end