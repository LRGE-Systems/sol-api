module Pdf::Contract::Classification
  class Work < Base

    private

    def template_file_name
      "contract_work.#{localeBase}.html"
    end
  end
end
