class Entrance::ItemsController < ApplicationController
  load_and_authorize_resource :campaign, class: 'Entrance::Campaign'
  load_and_authorize_resource :item,
                              through: :campaign, class: 'Entrance::CompetitiveGroupItem'

  def index ; end

  def show
    respond_to do |format|
      format.pdf {
        filename = "Протокол №#{@item.id}"
        Dir.chdir(Rails.root)
        url = "#{Dir.getwd}/lib/xsl"
        xml = Tempfile.new(['protocol', '.xml'])
        File.open(xml.path, 'w') do |file|
          file.write @item.to_xml(params[:name])
        end
        command = "java -cp #{Dir.getwd}/vendor/fop/build/fop.jar"
        Dir.foreach('vendor/fop/lib') do |file|
          command << ":#{Dir.getwd}/vendor/fop/lib/#{file}" if (file.match(/.jar/))
        end
        command << ' org.apache.fop.cli.Main '
        command << " -c #{url}/configuration.xml"
        command << " -xml #{xml.path}"
        command << " -xsl #{url}/protocol_print.xsl"
        command << ' -pdf -'
        document = `#{command}`

        send_data document,
                  type: 'application/pdf',
                  filename: "#{filename}.pdf",
                  disposition: 'inline'

        xml.close
        xml.unlink
      }
      format.xml { render xml: @item.to_xml(params[:name]) }
    end
  end
end