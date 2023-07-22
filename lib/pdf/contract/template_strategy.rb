module Pdf::Contract
  class TemplateStrategy
    def self.decide(contract:)
      klass = self.decideByClassificationName(className: contract.classification_name.downcase, contract: contract, bidding: nil)
      klass
    end

    def self.decideByClassificationName(className:, contract:, bidding:)
      klass = case className.downcase
      when 'bens'
        Pdf::Contract::Classification::Commodity
      when 'serviços'
        Pdf::Contract::Classification::Service
      when 'obras'
        Pdf::Contract::Classification::Work
      end
      klass.new(contract: contract, biddingTop: bidding)
    end
  end
end
