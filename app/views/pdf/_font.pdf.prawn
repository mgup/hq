pdf.font_families.update(
    'PT'=> {
        normal: Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf').to_s,
        italic: Rails.root.join('app', 'assets', 'fonts', 'PTF56F.ttf').to_s,
        bold:   Rails.root.join('app', 'assets', 'fonts', 'PTF75F.ttf').to_s})
pdf.font 'PT', size: 12