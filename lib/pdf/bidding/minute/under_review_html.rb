module Pdf::Bidding
  class Minute::UnderReviewHtml < Minute::Base
    private

    def bidding_not_able_to_generate?
      false
    end

    def template_file_name
      lastProposal = bidding.proposals.order(:updated_at => :desc).first.reload

      puts "LAST PROPOSAL"
      puts lastProposal.attributes
      
      if lastProposal.triage? || lastProposal.sent?
        return 'steps/step_2.html'
      elsif !(lastProposal.accepted? || lastProposal.refused? )
        @lot_proposals_override = lastProposal.lot_proposals.order(updated_at: :desc).first
        return 'steps/step_3.html' 
      end

    end
  end
end