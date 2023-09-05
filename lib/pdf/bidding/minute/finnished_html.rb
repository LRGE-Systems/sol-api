module Pdf::Bidding
  class Minute::FinnishedHtml < Minute::Base
    private

    def bidding_not_able_to_generate?
      !bidding.finnished?
    end

    def template_file_name
      puts "BIDDING GENERATING TEMPLATE FINISHED"

      lastStatus = bidding.versions.reload.reorder(:id=>:desc).first&.reify&.status
      puts "LAST STATUS"
      puts lastStatus

      lastEditedContract = bidding.contracts.order(:updated_at=>:desc).first.reload

      puts bidding.contracts.reload.all?{ |e| e.waiting_signature? } 
      puts bidding.contracts.reload.all?{ |e| e.completed? }
      puts bidding.contracts.reload.all?{ |e| e.all_signed? }
      puts bidding.contracts.reload.all?{ |e| e.total_inexecution? }

      if lastStatus == "reopened"
        @lot_proposals_override = bidding.lot_proposals.find{|d| d.proposal.contract.id == lastEditedContract.id}
        'steps/step_7_b.html'
      elsif lastEditedContract.waiting_signature?
        @lot_proposals_override = bidding.lot_proposals.find{|d| d.proposal.contract.id == lastEditedContract.id}
        'steps/step_4.html'
      elsif lastEditedContract.completed?
        @contract_override = lastEditedContract
        'steps/step_6.html'
      elsif lastEditedContract.total_inexecution? || lastEditedContract.partial_execution?
        @contract_override = lastEditedContract
        'steps/step_7_a.html'
      elsif lastEditedContract.all_signed?
        @contract_override = lastEditedContract
        'steps/step_5.html'
      else
        'minute_finnished.html'
      end
    end
  end
end
