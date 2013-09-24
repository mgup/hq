class OrdersController < ApplicationController
  def print
    @order = Document::Doc.first
    filename = 'name'
    Dir.chdir(Rails.root)
    url = "#{Dir.getwd}/public/xsl"
    command = "java -cp #{Dir.getwd}/vendor/fop/build/fop.jar"
    Dir.foreach('vendor/fop/lib') do |file|
      command << ":#{Dir.getwd}/vendor/fop/lib/#{file}" if (file.match(/.jar/))
    end
    command << ' org.apache.fop.cli.Main '
    command << " -xml #{url}/order.xml"
    command << " -xsl #{url}/print.xsl"
    command << ' -pdf -'

    document = `#{command}`

    send_data( document, type: 'application/pdf', filename: "#{filename}.pdf")
  end
end