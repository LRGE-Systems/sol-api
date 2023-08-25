module Pdf::Bidding
  class Minute::UnderReviewHtml < Minute::Base
    private

    def bidding_not_able_to_generate?
      false
    end

    def template_file_name
      if bidding.proposals.all?{ |x| x.triage? }
        'steps/step_2.html'
      elsif !bidding.proposals.all?{ |x| x.accepted? || x.refused? } 
        'steps/step_3.html' 
      end
    end
  end
end