prawn_document margin: [72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54,
                        72.0 * 1.0 / 2.54],
               page_layout: :landscape do |pdf|
  new_page = false
  @directions.each_with_index do |direction, i|
    pdf.font_size = 10
    # next unless direction.id == 197

    # next unless competitive_group.items.first.direction.master?

    render partial: 'protocol_permit_list', locals: { pdf: pdf,
                                            direction: direction, new_page: new_page }

  end
end
