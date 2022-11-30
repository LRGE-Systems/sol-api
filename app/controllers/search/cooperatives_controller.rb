module Search
  class CooperativesController < Search::BaseController

    private

    def base_resources
      Cooperative.for_user(current_user)
    end
  end
end
