module Pdf::Bidding
  class Minute::ReopenedHtml < Minute::Base
    private

    def bidding_not_able_to_generate?
      !bidding.reopened?
    end

    def template_file_name
      puts "BIDDING REOPENED GENERATING TEMPLATE FINISHED"

      lastEditedContract = bidding.contracts.order(:updated_at=>:desc).first.reload

      lpsal = bidding.lot_proposals.order(:updated_at => :desc).first.reload
      
      if lpsal.proposal.triage? && (lastEditedContract.total_inexecution? || lastEditedContract.partial_execution?)
        @contract_override = lastEditedContract
        return 'steps/step_7_a.html'
      elsif !(lpsal.proposal.accepted? || lpsal.proposal.refused?)
        @lot_proposals_override = lpsal
        return 'steps/step_3.html'
      else 
        @lot_proposals_override = lpsal
        return 'steps/step_4.html'
      end
    end
  end
end
