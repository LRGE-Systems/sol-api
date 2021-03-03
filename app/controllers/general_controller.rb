class GeneralController < ApplicationController
  # before_action -> { doorkeeper_authorize! :user }

  def search_info
    require 'net/http'
    url = URI.parse('http://wwd.cna.org.br/pls/cna/pkg_ws.consultacpfcnpj?id=1613230746&cpf_cnpj='+params[:cpf_cnpj])
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    bd = res.body
    dc = Hash.from_xml(bd)
    render json: dc
  end
end
