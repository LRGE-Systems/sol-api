module Administrator
  class BiddingsController < AdminController
    include CrudController

    load_and_authorize_resource

    expose :bidding
    expose :biddings, -> { find_biddings }

    private

    def resource
      bidding
    end

    def resources
      biddings.for_user(current_user)
    end

    def find_biddings
      Bidding.for_user(current_user).accessible_by(current_ability)
    end
  end
end
