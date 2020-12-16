module Coop
  class Biddings::ReviewsController < CoopController
    load_and_authorize_resource :bidding, parent: false

    expose :bidding

    before_action :set_paper_trail_whodunnit

    def update
      if updated?
        render status: :ok
      else
        render status: :unprocessable_entity
      end
    end

    private

    def updated?
      BiddingsService::UnderReview.call(bidding: bidding)
    end

    def resource
      bidding
    end
  end
end
