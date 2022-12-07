module ProposalService::Coop
  class AcceptBase
    include Call::Methods
    include TransactionMethods

    def main_method
      change_proposal_to_coop_accepted
    end

    private

    def change_proposal_to_coop_accepted
      execute_or_rollback do
        return unless proposal.sent? || proposal.triage?

        proposal.coop_accepted!
        proposal.reload
        update_proposal_at_blockchain!
        notify
      end
    end

    def update_proposal_at_blockchain!
      # response = Blockchain::Proposal::Update.call(proposal)
      # raise BlockchainError unless response.success?
    end

    # override
    def notify; end
  end
end
