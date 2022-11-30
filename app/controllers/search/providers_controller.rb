module Search
  class ProvidersController < Search::BaseController

    private

    def base_resources
      Provider.for_user(current_user)
    end
  end
end

