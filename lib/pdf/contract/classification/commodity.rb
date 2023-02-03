module Pdf::Contract::Classification
  class Commodity < Base

    private

    def template_file_name
      "contract_commodity.#{contract.user.organization.locale}.html"
    end
  end
end
