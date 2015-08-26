prawn_document margin: [72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54],
               page_layout: :landscape do |pdf|
  key = false
  @campaign.competitive_groups.each_with_index do |competitive_group, i|
    pdf.font_size = 10
    # next if competitive_group.items.first.payed?
    # next if i > 5

    # next unless competitive_group.items.first.direction.master?

    render partial: 'protocol_permit_list', locals: { pdf: pdf,
                                            group: competitive_group, key: key }

    key = true
  end
end
