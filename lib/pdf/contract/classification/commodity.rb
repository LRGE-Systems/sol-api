module Pdf::Contract::Classification
  class Commodity < Base

    private

    def template_file_name
      "contract_commodity.#{localeBase}.html"
    end
  end
end
