module Pdf::Bidding
  class Minute::FinnishedHtml < Minute::Base
    private

    def bidding_not_able_to_generate?
      !bidding.finnished?
    end

    def template_file_name
      puts "BIDDING GENERATING TEMPLATE FINISHED"
      puts bidding.contracts.all?{ |e| e.waiting_signature? } 
      puts bidding.contracts.all?{ |e| e.all_signed? }
      if bidding.contracts.all?{ |e| e.waiting_signature? }
        'steps/step_4.html'
      elsif bidding.contracts.all?{ |e| e.completed? }
        'steps/step_6.html'
      elsif bidding.contracts.all?{ |e| e.all_signed? }
        'steps/step_5.html'
      else
        'minute_finnished.html'
      end
    end
  end
end
