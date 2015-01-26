pdf.font_families.update(
    'PTSerif'=> {
        normal: Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf').to_s,
        italic: Rails.root.join('app', 'assets', 'fonts', 'PTF56F.ttf').to_s,
        bold:   Rails.root.join('app', 'assets', 'fonts', 'PTF75F.ttf').to_s})
pdf.font 'PTSerif', size: 12

require "prawn/table"