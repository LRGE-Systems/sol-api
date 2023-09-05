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
              when 'reopened'
                Pdf::Bidding::Minute::ReopenedHtml
              when 'failure'
                Pdf::Bidding::Minute::FailureHtml
              when 'desert'
                Pdf::Bidding::Minute::DesertHtml
              end
      puts klass
      klass.new(bidding: bidding)
    end
  end
end
