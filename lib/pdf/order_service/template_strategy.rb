module Pdf::OrderService
  class TemplateStrategy
    def self.decide(contract:)
      # klass = case contract.classification_name.downcase
      #         when 'bens'
      #           Pdf::BuyApproval::Classification::Commodity
      #         when 'serviços'
      #           Pdf::BuyApproval::Classification::Service
      #         when 'obras'
               
      #         end
        Pdf::OrderService::Classification::Base.new(contract: contract)
    end

  end
end
