prawn_document margin: [72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54],
               page_layout: :landscape do |pdf|
  @campaign.competitive_groups.each do |competitive_group|
    # next if competitive_group.items.first.payed?

    render partial: 'protocol_permit_list', locals: { pdf: pdf,
                                            group: competitive_group }

    pdf.start_new_page
  end
end