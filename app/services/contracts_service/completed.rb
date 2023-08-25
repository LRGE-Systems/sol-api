module ContractsService
  class Completed < ContractsService::Base

    private

    def contract_status!
      contract.completed!
      sleep 2
      generate_minute
    end

    def notify
      Notifications::Contracts::Completed.call(contract: contract)
    end

    def generate_minute
      Bidding::Minute::PdfGenerateWorker.perform_async(contract.bidding.id)
    end
  end
end
