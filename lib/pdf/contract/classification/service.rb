module Pdf::Contract::Classification
  class Service < Base

    private

    def template_file_name
      "contract_service.#{localeBase}.html"
    end
  end
end
