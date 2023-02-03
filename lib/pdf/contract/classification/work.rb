module Pdf::Contract::Classification
  class Work < Base

    private

    def template_file_name
      "contract_work.#{contract.user.organization.locale}.html"
    end
  end
end
