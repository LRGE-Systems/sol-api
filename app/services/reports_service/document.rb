module ReportsService
  class Document < ReportsService::BaseContract

    private

    def classifications
      @classifications =  ::Document.document_types.keys
    end

    def classification_contracts(classification)
      contracts_base = ::Contract.by_document_type(classification).all
      contracts_base.uniq.flatten
    end

    def classification_children_contracts(classification)
      # classification_ids = classification.children_classifications.map(&:id)
      # by_classification(classification_ids).uniq
    end

    def name_count_price(contracts, classification)
      {
        label: classification,
        data: {
          countable: contracts.count,
          price_total: price_total(contracts)
        }
      }
    end
  end
end
