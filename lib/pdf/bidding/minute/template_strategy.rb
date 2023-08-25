module Pdf::Bidding
  class Minute::TemplateStrategy
    def self.decide(bidding:)
      puts "!!!!!!!!!!!!! DECIDING TEMPLATE !!!!!!!!!!!!!!!!"
      puts bidding.status
      klass = case bidding.status
              when 'under_review'
                Pdf::Bidding::Minute::UnderReviewHtml
              when 'approved'
                Pdf::Bidding::Minute::ApprovedHtml 
              when 'finnished'
                Pdf::Bidding::Minute::FinnishedHtml
              when 'failure'
                Pdf::Bidding::Minute::FailureHtml
              when 'desert'
                Pdf::Bidding::Minute::DesertHtml
              end
      klass.new(bidding: bidding)
    end
  end
end
