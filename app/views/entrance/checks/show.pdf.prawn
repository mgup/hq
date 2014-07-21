prawn_document do |pdf|
  render 'pdf/font', pdf: pdf

  render partial: 'check', locals: { pdf: pdf, check: @check, entrant: @entrant }
end