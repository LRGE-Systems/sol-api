module Supp
  class BiddingsController < SuppController
    include CrudController

    load_and_authorize_resource

    expose :biddings, -> { find_biddings }
    expose :bidding

    private

    def resource
      bidding
    end

    def resources
      biddings.for_user(current_provider)
    end

    def find_biddings
      Bidding.for_user(current_provider).by_provider(current_provider).accessible_by(current_ability).distinct('biddings.id')
    end
  end
end
