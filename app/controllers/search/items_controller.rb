module Search
  class ItemsController < Search::BaseController

    private

    def base_resources
      Item.for_user(current_user)
    end
  end
end
