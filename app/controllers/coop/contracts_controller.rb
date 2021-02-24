module Coop
  class ContractsController < CoopController
    include BaseContractsController

    load_and_authorize_resource :contract, class: 'Contract'

    def updateDoc 
      contract.create_document!(
        file: params[:documentFile],
        document_date: params[:documentDate],
        document_number: params[:documentNumber] ,
        document_type: params[:documentType] ,
      )
      contract.save!
      render json: contract.document.try(:file).try(:url)
    end

    private

    def find_contracts
      current_cooperative.contracts.accessible_by(current_ability)
    end
  end
end
