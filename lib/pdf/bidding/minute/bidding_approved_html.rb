module Pdf::Bidding
  class Minute::ApprovedHtml < Minute::Base
    private

    def bidding_not_able_to_generate?
      !bidding.approved?
    end

    def template_file_name
      'steps/step_1.html'
    end
  end
end