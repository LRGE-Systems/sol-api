module Pdf::Contract::Classification
  class Service < Base

    private

    def template_file_name
      "contract_service.#{contract.user.organization.locale}.html"
    end
  end
end
