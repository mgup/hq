class BlanksController < ApplicationController
  load_and_authorize_resource class: 'Document::Doc'

  def transfer_protocols
    @blanks = @blanks.transfer_protocols
  end

end